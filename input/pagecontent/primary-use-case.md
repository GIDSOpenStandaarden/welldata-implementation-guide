### Primary use case overview

{::nomarkdown}
{% include welldata-primary-usecase.svg %}
{:/}

The following sequence diagram describes user interactions and backend processes in the **Well Data Portal** ecosystem. It involves user authentication, application launches, questionnaire handling, and analysis, with interactions between multiple participants and services.

---

###### Key Participants and Their Roles
- **User**: The end-user interacting with the system.
- **Well Data Portal (portal)**: Provides access and acts as a gateway to various services.
- **Athumi Approved IdP (idp)**: Handles Solid OIDC login for authenticating the user.
- **Selfcare**: Core service managing application launches, questionnaire workflows, and interactions with other services.
- **Bibopp**: Participant not elaborated upon extensively in this diagram.
- **Zipster**: Processes FHIR questionnaires and performs analysis.
- **User POD (pod)**: Stores and secures user-specific data.
- **We Are IDP**: Authenticates the Selfcare application and facilitates access token generation.
- **Athumi VC Service (avcs)**: Manages access requests and grants for retrieving and storing user data from/to the POD.
- **We Are AMA**: Enables the user to review and approve access requests from Selfcare.

---

###### Grouped Processes in the Diagram

####### 1. Login
- **User** accesses the Well Data Portal (**portal**).
- **Portal** redirects the user to **IdP** for login.
- User authenticates with **Athumi Approved IdP (idp)** using Solid OIDC login.
- Authentication results in the portal receiving an **access token** containing the user's WebID.

---

####### 2. Launch
- The user selects **Selfcare** from the **portal**.
- **Portal** redirects the user to **Selfcare** with an HTI launch, passing the WebID.
- **Selfcare**:
  1. Validates the request.
  2. Authenticates itself with **We Are IDP** using client credentials.
  3. Initiates an access request via **Athumi VC Service (avcs)** to access the user’s POD on a specified container.

- The user is redirected to **We Are AMA**, where they:
  1. Authenticate via **IdP**.
  2. Approve the POD access request.

- **We Are AMA** facilitates creating an access grant via **Athumi VC Service (avcs)**.
- Access grant confirmation flows back to **Selfcare**, and the user is redirected to **Selfcare** for further interaction.

---

####### 3. Questionnaire
######## Steps:
1. The user selects a questionnaire in **Selfcare**.
2. **Selfcare** requests an **FHIR questionnaire** from **Zipster**, which sends back the questionnaire.
3. The questionnaire is displayed to the user by **Selfcare**.

######## Data Retrieval:
- **Selfcare** may load existing FHIR data from the **User POD**, based on:
  - **Access grants** retrieved from **Athumi VC Service (avcs)**.
  - Identifiers (e.g., SNOMED concepts) that inform which resources to use.

######## Data Entry:
- The user fills out the questionnaire in **Selfcare** through an iterative process:
  1. Each response is submitted to **Selfcare**.
  2. **Selfcare** updates the questionnaire responses in the **User POD** (under the `/questionnaireresponse` container).
  3. Responses are confirmed and the next question is rendered.

---

####### 4. Analysis
- Upon questionnaire completion, **Selfcare** sends the responses to **Zipster**.
- **Zipster**:
  1. Processes the responses.
  2. Calculates health care services using FHIR and codable concepts.

- Results from **Zipster** flow back to **Selfcare**, where:
  1. **Codable concepts** are stored in the **User POD**.
  2. The user is presented with the advised care services.

---

###### Key Notes from the Diagram
1. **HTI Launch**: The purpose of passing the WebID via the HTI launch is questioned in the diagram.
2. **FHIR Questionnaires**:
   - Existing FHIR data from the POD could be used in the questionnaire.
   - There's a focus on how to identify relevant resources (e.g., based on SNOMED identifiers).
3. **Access Management**:
   - All access to POD resources is regulated through access grants managed by **Athumi VC Service**.
4. **Data Security**:
   - After processing, user data (e.g., Questionnaire Responses, FHIR resources, or codable concepts) is securely stored in the **User POD**.

---

This diagram highlights a well-defined flow of authentication, data interoperability, and secure participant interactions. Each process ensures proper user authentication, controlled access to resources, and data privacy.
