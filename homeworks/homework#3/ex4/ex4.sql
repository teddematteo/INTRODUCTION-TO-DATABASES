/*SERVICE_BOOKING(-BookingID-, LicensePlate, Model, Brand, RequestDate)
BOOKING_AVAILABILITY(-Date-, OpeningTime, ClosingTime, AvailableSlots)
REQUESTED_SERVICES(-LicensePlate-, -ServiceType-)
SERVICE_COSTS(-ServiceType-, -Brand-, -Model-, Cost)
SERVICE_NOTIFICATION(-BookingID-, LicensePlate, ServiceDate, OpeningTime, ClosingTime, TotalCost)


Write a trigger to manage the bookings for vehicle service at a specialized workshop.

A booking request for vehicle service is inserted (a record is inserted into the SERVICE_BOOKING table), specifying the type of vehicle (brand and model) and the date when the service is requested (attribute RequestDate). The trigger must perform the following operations:

Select the first date (on or after the requested date) where there are still available slots. The BOOKING_AVAILABILITY table indicates, for each date, the opening and closing times of the workshop, and the number of slots still available for vehicle service on that date.

If there are no available slots on any date, the booking request must be canceled. Otherwise, the following operations must be performed:

Update the number of available slots on the selected date.
Calculate the total cost of the service. The REQUESTED_SERVICES table stores the list of service types requested for the vehicle booked for service. The SERVICE_COSTS table stores the cost for each service type based on the brand and model of the vehicle.
Notify the successful booking by inserting a new record into the SERVICE_NOTIFICATION table, providing details about the selected date and the opening and closing times on that date, and the total cost for the service.*/

CREATE OR REPLACE TRIGGER ServiceBooking
BEFORE INSERT ON SERVICE_BOOKING
FOR EACH ROW

DECLARE
    N NUMBER;
    TOTCOST NUMBER;
    D DATE;
    OP DATE;
    CL DATE;
BEGIN
    SELECT MIN(Date) INTO D -- first available date
    FROM BOOKING_AVAILABILITY
    WHERE Date >= :NEW.RequestDate AND AvailableSlots > 0

    IF (D IS NULL) THEN
        RAISE_APPLICATION_ERROR(X,'No available slots'); -- we prevent from inserting of the booking request
    ELSE
        UPDATE BOOKING_AVAILABILITY -- update number of slots
        SET AvailableSlots = AvailableSlots - 1
        WHERE Date = D;

        SELECT SUM(SC.Cost) INTO TOTCOST -- sum of the costs for all services related to that license plate
        FROM REQUESTED_SERVICES RS, SERVICE_COSTS SC
        WHERE RS.ServiceType = SC.ServiceType AND SC.Brand = :NEW.Brand AND SC.Model = :NEW.Model
              AND RS.LicensePlate = :NEW.LicensePlate;

        SELECT OpeningTime, ClosingTime INTO OP, CL -- read opening and closing time
        FROM BOOKING_AVAILABILITY
        WHERE Date = D;

        INSERT INTO SERVICE_NOTIFICATION (BookingID, LicensePlate, ServiceDate, OpeningTime, ClosingTime, TotalCost)
        VALUES (:NEW.BookingID, :NEW.LicensePlate, D, OP, CL, TOT);
    END IF;
END;