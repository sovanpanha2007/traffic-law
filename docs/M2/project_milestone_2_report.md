# CADT | IDT — Mobile Dev Term 1 - Gen 11
## Project - Milestone 2

In **MILESTONE-1**, you focused on the business:
* Goal of your application
* Who is using the application
* Use case diagram
* Functional requirements

In **MILESTONE-2**, you will develop the **MODEL**, the **SERVICE**, and **TEST** your services:
* Model layer
* Business logic in services, including the operation preconditions
* Tests

---

## 1. Architecture

Your project must follow the directory structure below:

```text
├── lib/
│   ├── model/
│   │   ├── ...
│   │   └── ...
│   └── service/
│       └── ...
└── test/
    └── ...
```

* **`model/`**: Contains the classes representing the business domain.
* **`service/`**: Contains the business operations and rules.
* **`test/`**: Contains tests for the service operations.

---

## 2. Model Layer

The Model layer represents the objects and concepts of your business domain. Design your classes using appropriate Object-Oriented Programming (OOP) principles.

### Mandatory Requirements
* At least **3** classes or entities.
* At least **2** composition or aggregation relationships.
* Appropriate constructors, attributes, and methods.

### Example: Travel Management System
* **Trip**
  * `Destination`
  * `List<Activity>`
* **Traveler**
  * `List<Booking>`
* **Booking**
  * `List<Passenger>`

---

## 3. Service Layer

The Service layer implements the business operations performed using your model objects.
> *The model represents the things in the system; the service defines what the system can do with them.*

### Mandatory Requirements
* At least **3** meaningful business operations.
* Operations that use your model objects.
* At least **1** operation involving multiple entities.
* At least **1** business rule or validation.

### Example: `ReservationService`
* `createReservation(...)`
* `cancelReservation(...)`
* `isRoomAvailable(...)`
* `calculatePrice(...)`

**Example of a business rule:**
> A reservation cannot be created if the room is already booked for the requested dates.

---

## 4. Test Layer

The Test layer verifies that your service operations behave correctly under different conditions.

### Mandatory Requirements
* Verify the correctness of your business operations.
* Cover different business scenarios.
* Include at least **5** test cases in total.

Your test cases must cover:
* **Normal cases:** Valid inputs and expected successful operations.
* **Invalid cases:** Invalid inputs or operations that violate business rules.
* **Boundary or special cases:** Edge conditions that may affect the result.

### Example: Hotel Management System — `createReservation()`
1. Creating a reservation for an available room.
2. Attempting to reserve a room that is already booked.
3. Attempting to create a reservation with invalid dates.
4. Attempting to reserve a non-existing room.
5. Creating a reservation at the boundary of room availability.