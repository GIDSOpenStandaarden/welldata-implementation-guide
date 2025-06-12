# VKN OIDC to WebID Integration Specification

## Overview

This specification describes how to update the existing Verslavingskunde Nederland (VKN) OIDC implementation to automatically create WebIDs for anonymous users through integration with the Athumi Pod Platform API. This enables anonymous users authenticated via the GIDS Anonymous Login system to seamlessly access WellData ecosystem services with their own Solid pods.

## Background

The current VKN implementation provides anonymous authentication through the MS Auth middleware using OAuth2 Authorization Code Flow. Users receive anonymous identifiers that allow for recurring identification without revealing personal information. To integrate with the WellData ecosystem, these anonymous users need WebIDs and corresponding Solid pods for data storage and interoperability.

## Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   Application   │───▶│   MS Auth        │───▶│   Enhanced VKN      │
│                 │    │   Middleware     │    │   Backend           │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
                                                         │
                                                         ▼
                                               ┌─────────────────────┐
                                               │   Athumi Pod        │
                                               │   Platform API      │
                                               └─────────────────────┘
                                                         │
                                                         ▼
                                               ┌─────────────────────┐
                                               │   User's Solid Pod  │
                                               └─────────────────────┘
```

## Implementation Requirements

### 1. Prerequisites

- Existing VKN OIDC implementation with MS Auth middleware
- Valid credentials for Athumi Pod Platform API
- HTTPS endpoints for all services
- Proper error handling and logging mechanisms

### 2. Authentication Flow Extensions

#### Step 1: Standard Anonymous Authentication
Continue with the existing OAuth2 flow as documented:

1. Redirect user to authorization endpoint
2. User completes MS Auth middleware interaction
3. User returns with authorization code
4. Exchange code for access_token and id_token

#### Step 2: WebID Creation Process

After successful authentication and JWT validation, implement the following:

```typescript
async function handlePostAuthentication(idToken: string) {
    try {
        // 1. Extract user identifier from JWT
        const userInfo = validateAndExtractJWT(idToken);
        const anonymousUserId = userInfo.sub; // Anonymous user ID
        
        // 2. Check if WebID already exists
        const existingWebId = await checkExistingWebId(anonymousUserId);
        if (existingWebId) {
            return existingWebId;
        }
        
        // 3. Create new WebID and pod
        const webId = await createWebIdForAnonymousUser(anonymousUserId);
        
        // 4. Store mapping for future reference
        await storeUserWebIdMapping(anonymousUserId, webId);
        
        return webId;
        
    } catch (error) {
        console.error('WebID creation failed:', error);
        // Decide whether to continue without WebID or fail
        throw new Error('WebID creation failed');
    }
}
```

### 3. Athumi Pod Platform Integration

#### Configuration Requirements

```typescript
interface PodPlatformConfig {
    baseUrl: string;           // "https://pod-platform.api.athumi.eu"
    clientCredentials: {
        clientId: string;
        clientSecret: string;
    };
    correlationIdGenerator: () => string;
}
```

#### WebID Creation Implementation

```typescript
async function createWebIdForAnonymousUser(anonymousUserId: string): Promise<string> {
    // 1. Obtain SOLID OIDC token for citizen authentication
    const solidToken = await getSolidOIDCToken(anonymousUserId);
    
    // 2. Call Athumi Pod Platform to create WebID and pod
    const webId = await createWebIdViaPodPlatform(solidToken);
    
    return webId.uri;
}

async function createWebIdViaPodPlatform(solidToken: string): Promise<WebId> {
    const correlationId = generateCorrelationId();
    
    const response = await fetch(`${POD_PLATFORM_BASE_URL}/v1/webids`, {
        method: 'PUT',
        headers: {
            'Authorization': `Bearer ${solidToken}`,
            'X-Correlation-Id': correlationId,
            'Content-Type': 'application/json'
        }
    });
    
    if (!response.ok) {
        const error = await response.json();
        throw new Error(`WebID creation failed: ${error.detail}`);
    }
    
    return await response.json();
}
```

### 4. Token Management

#### SOLID OIDC Token Generation

The VKN backend needs to generate SOLID OIDC tokens for anonymous users:

```typescript
async function getSolidOIDCToken(anonymousUserId: string): Promise<string> {
    // Generate SOLID OIDC token with anonymous user as subject
    // This should include the anonymous user ID in the sub claim
    // and conform to SOLID OIDC specifications
    
    const tokenPayload = {
        sub: anonymousUserId,
        iss: VKN_ISSUER_URL,
        aud: POD_PLATFORM_BASE_URL,
        exp: Math.floor(Date.now() / 1000) + 3600, // 1 hour
        iat: Math.floor(Date.now() / 1000),
        webid: `${VKN_BASE_URL}/webid/${anonymousUserId}` // Temporary WebID reference
    };
    
    return jwt.sign(tokenPayload, PRIVATE_KEY, { algorithm: 'RS256' });
}
```

### 5. Data Storage and Mapping

#### User-WebID Mapping Storage

```typescript
interface UserWebIdMapping {
    anonymousUserId: string;
    webId: string;
    createdAt: Date;
    lastAccessed: Date;
}

// Store mapping in secure database
async function storeUserWebIdMapping(
    anonymousUserId: string, 
    webId: string
): Promise<void> {
    const mapping: UserWebIdMapping = {
        anonymousUserId,
        webId,
        createdAt: new Date(),
        lastAccessed: new Date()
    };
    
    await database.userWebIdMappings.create(mapping);
}

// Retrieve existing WebID for user
async function checkExistingWebId(anonymousUserId: string): Promise<string | null> {
    const mapping = await database.userWebIdMappings.findOne({
        anonymousUserId
    });
    
    if (mapping) {
        // Update last accessed
        await database.userWebIdMappings.updateOne(
            { anonymousUserId },
            { lastAccessed: new Date() }
        );
        
        return mapping.webId;
    }
    
    return null;
}
```

### 6. Enhanced JWT Response

Update the existing JWT response to include WebID information:

```typescript
async function generateEnhancedJWT(originalJWT: any, webId: string): Promise<string> {
    const enhancedPayload = {
        ...originalJWT,
        webid: webId,  // Add WebID to JWT payload
        pod_access: true,  // Indicate pod access availability
        welldata_integration: true  // Flag for WellData ecosystem integration
    };
    
    return jwt.sign(enhancedPayload, PRIVATE_KEY, { algorithm: 'RS256' });
}
```

### 7. Error Handling and Fallback

```typescript
class WebIdCreationError extends Error {
    constructor(message: string, public readonly cause?: Error) {
        super(message);
        this.name = 'WebIdCreationError';
    }
}

async function handleWebIdCreationWithFallback(anonymousUserId: string): Promise<string | null> {
    try {
        return await createWebIdForAnonymousUser(anonymousUserId);
    } catch (error) {
        console.error(`WebID creation failed for user ${anonymousUserId}:`, error);
        
        // Log for monitoring and debugging
        await logWebIdCreationFailure(anonymousUserId, error);
        
        // Depending on requirements, either:
        // 1. Return null and continue without WebID
        // 2. Retry with exponential backoff
        // 3. Throw error and fail authentication
        
        return null; // Graceful degradation
    }
}
```

### 8. Configuration Updates

#### Environment Variables

Add the following environment variables to the VKN configuration:

```bash
# Athumi Pod Platform Configuration
POD_PLATFORM_BASE_URL=https://pod-platform.api.athumi.eu
POD_PLATFORM_CLIENT_ID=your_client_id
POD_PLATFORM_CLIENT_SECRET=your_client_secret

# WebID Creation Settings
WEBID_CREATION_ENABLED=true
WEBID_CREATION_TIMEOUT=10000  # 10 seconds
WEBID_FALLBACK_MODE=graceful  # graceful | strict

# VKN Specific Settings
VKN_ISSUER_URL=https://ms-auth.sns.gidsopenstandaarden.org
VKN_BASE_URL=https://your-vkn-backend.example.com

# Database for WebID mappings
WEBID_MAPPING_DB_URL=your_database_connection_string
```

### 9. API Flow Integration

#### Updated Step 4: Enhanced Token Response

Modify the existing Step 4 (unpack and validate id_token) to include WebID creation:

```typescript
async function enhancedStep4(idToken: string): Promise<AuthResult> {
    // Original validation
    const tokenData = validateJWT(idToken);
    
    // New: WebID creation/retrieval
    const webId = await handleWebIdCreationWithFallback(tokenData.sub);
    
    // Enhanced response
    const authResult: AuthResult = {
        userId: tokenData.sub,
        webId: webId,
        originalToken: idToken,
        enhancedToken: webId ? await generateEnhancedJWT(tokenData, webId) : idToken,
        podAccess: !!webId
    };
    
    return authResult;
}
```

### 10. Monitoring and Logging

```typescript
interface WebIdMetrics {
    totalCreations: number;
    successfulCreations: number;
    failedCreations: number;
    averageCreationTime: number;
}

async function logWebIdCreationFailure(
    anonymousUserId: string, 
    error: Error
): Promise<void> {
    const logEntry = {
        timestamp: new Date(),
        anonymousUserId: anonymousUserId,
        errorType: error.name,
        errorMessage: error.message,
        stackTrace: error.stack,
        correlationId: getCurrentCorrelationId()
    };
    
    await errorLogger.log(logEntry);
    
    // Optional: Send alerts for high failure rates
    await checkAndAlertOnFailureRates();
}
```

### 11. Testing Strategy

#### Unit Tests

```typescript
describe('WebID Creation Integration', () => {
    test('should create WebID for new anonymous user', async () => {
        const mockUserId = 'anon_user_123';
        const expectedWebId = 'https://pod.example.com/webid/123';
        
        // Mock Pod Platform API response
        mockPodPlatformAPI.createWebId.mockResolvedValue({
            uri: expectedWebId
        });
        
        const result = await createWebIdForAnonymousUser(mockUserId);
        
        expect(result).toBe(expectedWebId);
        expect(mockPodPlatformAPI.createWebId).toHaveBeenCalledWith(
            expect.objectContaining({
                headers: expect.objectContaining({
                    'Authorization': expect.stringContaining('Bearer')
                })
            })
        );
    });
    
    test('should return existing WebID for returning user', async () => {
        const mockUserId = 'anon_user_456';
        const existingWebId = 'https://pod.example.com/webid/456';
        
        // Setup existing mapping
        await storeUserWebIdMapping(mockUserId, existingWebId);
        
        const result = await handlePostAuthentication(createMockJWT(mockUserId));
        
        expect(result).toBe(existingWebId);
        // Should not call Pod Platform API
        expect(mockPodPlatformAPI.createWebId).not.toHaveBeenCalled();
    });
});
```

#### Integration Tests

```typescript
describe('Full Authentication Flow with WebID', () => {
    test('should complete authentication and create WebID', async () => {
        // Test full flow from authorization code to WebID creation
        const authCode = 'test_auth_code';
        const mockIdToken = createMockIdToken();
        
        // Mock MS Auth middleware response
        mockAuthMiddleware.exchangeCode.mockResolvedValue({
            access_token: 'access_token',
            id_token: mockIdToken
        });
        
        // Mock Pod Platform
        mockPodPlatformAPI.createWebId.mockResolvedValue({
            uri: 'https://pod.example.com/webid/test'
        });
        
        const result = await processAuthenticationFlow(authCode);
        
        expect(result.webId).toBeDefined();
        expect(result.podAccess).toBe(true);
    });
});
```

## Migration Plan

### Phase 1: Infrastructure Setup
1. Set up Athumi Pod Platform API credentials
2. Create database schema for WebID mappings
3. Implement configuration management
4. Set up monitoring and logging

### Phase 2: Core Implementation
1. Implement WebID creation logic
2. Add user-WebID mapping storage
3. Update JWT handling to include WebID
4. Implement error handling and fallback mechanisms

### Phase 3: Integration and Testing
1. Integrate with existing authentication flow
2. Comprehensive testing (unit, integration, end-to-end)
3. Performance testing and optimization
4. Security review and penetration testing

### Phase 4: Deployment and Monitoring
1. Gradual rollout with feature flags
2. Monitor WebID creation success rates
3. Performance monitoring and optimization
4. User feedback collection and iteration

## Security Considerations

### Authentication Security
- Validate all JWT tokens according to existing security standards
- Ensure SOLID OIDC tokens are properly signed and have appropriate expiration
- Implement rate limiting for WebID creation requests

### Data Protection
- Encrypt WebID mappings in database
- Implement proper access controls for mapping data
- Ensure anonymous user IDs remain unlinkable to real identities
- Regular security audits of the integration

### Privacy Preservation
- WebID creation must not compromise anonymity
- Implement data retention policies for WebID mappings
- Provide user control over WebID and pod deletion
- Ensure compliance with GDPR and other privacy regulations

## Performance Considerations

### Scalability
- Implement caching for WebID lookups
- Use connection pooling for database and API calls
- Consider async processing for WebID creation
- Monitor and optimize API response times

### Reliability
- Implement circuit breakers for Pod Platform API calls
- Add retry logic with exponential backoff
- Graceful degradation when WebID creation fails
- Health checks and monitoring alerts

## Conclusion

This specification provides a comprehensive approach to integrating WebID creation into the existing VKN OIDC implementation. The enhanced system will enable anonymous users to seamlessly access the WellData ecosystem while maintaining their privacy and anonymity. The implementation prioritizes reliability, security, and user experience while providing appropriate fallback mechanisms for system resilience.