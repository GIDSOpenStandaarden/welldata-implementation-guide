### Primary use case overview

{% include welldata-primary-usecase.svg %}

The sequence diagram describes the interactions between a **User**, **WellData**, **Module**, **AMA (Access Management)**, **IdP (Identity Provider)**, and **Pod**. The flow is grouped into three major processes, detailing how data is accessed and tasks are managed.

---

#### **1. WellData Group: Initial Access and Task Management**

1. **Start Interaction**:
   - The **User** initiates interaction by sending a `start` request to **WellData**.

2. **Request POD Access**:
   - **WellData** communicates with **AMA** to request POD access.
   - **AMA** interacts with **IdP** to log in using `[WEB-ID]`.
   - The **User** consents to this access, facilitated by **AMA**.

3. **POD Handle and IDs**:
   - Once authenticated, **AMA** returns `[POD handle]` and `[WEB-ID]` to **WellData**.

4. **Module Selection**:
   - The **User** selects a module in **WellData**, prompting it to create or update a `[Task]` in **Pod**.

---

#### **2. Module Group: Task Execution via HTI**

1. **Launching HTI**:
   - The **User** launches an HTI (task execution interface) in **Module** (Selfcare / BeBob) using `[WEB-ID]` and `[TASK]`.

2. **Request POD Access**:
   - **Module** requests POD access from **AMA**, providing `[WEB-ID]` for authentication.
   - Similar to earlier interactions, **AMA** interacts with **IdP** for re-login, after which the **User** provides consent.
   - **AMA** returns `[POD handle]` and `[WEB-ID]` to **Module**.

3. **Data Operations**:
   - **Module** interacts with **Pod** to:
     - **Read data** related to the task.
     - Perform the given `[TASK]` internally.
     - **Store progress data** back in **Pod**.

---

#### **3. WellData Group: Task Fetch and Status Reporting**

1. **Restart Interaction**:
   - The **User** re-initiates a `start` request to **WellData**.

2. **Request POD Access**:
   - **WellData** communicates with **AMA** for POD access. This triggers the following:
     - **IdP** re-login using `[WEB-ID]`.
     - The **User** provides consent again.
   - **AMA** returns `[POD handle]` and `[WEB-ID]` to **WellData**.

3. **Task Fetch**:
   - **WellData** retrieves the relevant `[Task]` data from **Pod**.

4. **Task Status**:
   - **WellData** processes and returns the task status to the **User**, showing the current progress or completion state.

---

#### **Notable Entities**

- **User**: Interacts with WellData and the Module to initiate processes and manage tasks.
- **WellData**: Orchestrates communication between AMA, Pod, and the User for task creation, updates, and access.
- **Module (Selfcare / BeBob)**: Handles task execution by interacting with Pod and AMA during the process.
- **AMA (We Are Access Management)**: Manages access to Pods by handling authentication (via IdP) and obtaining necessary credentials.
- **IdP (Identity Provider)**: Performs authentication tasks (login and re-login) to verify User credentials.
- **Pod**: Stores and handles data related to tasks, serving as the backend storage for operations.

---

#### **High-Level Process Summary**

The sequence diagram illustrates a multi-stage workflow for task management and execution:
1. Access initiation happens via **WellData**, which authenticates the **User** and exchanges task data with **Pod**.
2. Task execution occurs via the **Module**, with secure access managed by **AMA** and live interaction with **Pod**.
3. Task status updates and data retrieval are handled by **WellData**, ensuring the User stays informed about progress.

---
