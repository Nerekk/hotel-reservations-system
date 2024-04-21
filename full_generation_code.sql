--------------------------------------------------------
--  File created - poniedzia≥ek-stycznia-29-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Type ADDRESS_T
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."ADDRESS_T" AS OBJECT (
    address_id NUMBER,
    city VARCHAR2(50),
    street VARCHAR2(50),
    apartment_number VARCHAR2(10),
    
    CONSTRUCTOR FUNCTION ADDRESS_T(
        v_city IN VARCHAR2,
        v_street IN VARCHAR2,
        v_apartment_number IN VARCHAR2
    ) RETURN SELF AS RESULT
);
/
CREATE OR REPLACE TYPE BODY "MATI"."ADDRESS_T" AS

    CONSTRUCTOR FUNCTION ADDRESS_T(
        v_city IN VARCHAR2,
        v_street IN VARCHAR2,
        v_apartment_number IN VARCHAR2
    ) RETURN SELF AS RESULT IS
    BEGIN
        self.address_id := seq_addr.nextval;
        self.city := v_city;
        self.street := v_street;
        self.apartment_number := v_apartment_number;
        RETURN;
    END;

END;

/
--------------------------------------------------------
--  DDL for Type CUSTOMER_T
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."CUSTOMER_T" AS OBJECT (
    customer_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    address ref ADDRESS_T,
    email_address VARCHAR2(50),
    phone_number VARCHAR2(20),
    
    CONSTRUCTOR FUNCTION CUSTOMER_T(
        v_first_name IN VARCHAR2,
        v_last_name IN VARCHAR2,
        v_address IN ref ADDRESS_T,
        v_email_address IN VARCHAR2,
        v_phone_number IN VARCHAR2
    ) RETURN SELF AS RESULT
);
/
CREATE OR REPLACE TYPE BODY "MATI"."CUSTOMER_T" AS

    CONSTRUCTOR FUNCTION CUSTOMER_T(
        v_first_name IN VARCHAR2,
        v_last_name IN VARCHAR2,
        v_address IN ref ADDRESS_T,
        v_email_address IN VARCHAR2,
        v_phone_number IN VARCHAR2
    ) RETURN SELF AS RESULT IS
    BEGIN
        self.customer_id := seq_customer.nextval;
        self.first_name := v_first_name;
        self.last_name := v_last_name;
        self.address := v_address;
        self.email_address := v_email_address;
        self.phone_number := v_phone_number;
        RETURN;
    END;

END;

/
--------------------------------------------------------
--  DDL for Type EMPLOYEE_T
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."EMPLOYEE_T" AS OBJECT (
    emp_id NUMBER,
    hotel_id NUMBER,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    hire_date DATE,
    salary NUMBER,
    job VARCHAR2(50)
);

/
--------------------------------------------------------
--  DDL for Type GUESTS_VARRAY
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."GUESTS_VARRAY" AS VARRAY(3) OF NUMBER

/
--------------------------------------------------------
--  DDL for Type HOTEL_T
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."HOTEL_T" AS OBJECT (
    hotel_id NUMBER,
    name VARCHAR2(50),
    star_rating NUMBER(1),
    rooms ROOMS_NT,
    reservations RESERVATIONS_NT,
    
    MEMBER PROCEDURE set_stars(v_stars IN NUMBER),
    MEMBER PROCEDURE set_name(new_name IN NUMBER)
);
/
CREATE OR REPLACE TYPE BODY "MATI"."HOTEL_T" AS

    MEMBER PROCEDURE set_stars(v_stars IN NUMBER) AS
    BEGIN
        self.star_rating := v_stars;
    END set_stars;

    MEMBER PROCEDURE set_name(new_name IN NUMBER) AS
    BEGIN
        self.name := new_name;
    END set_name;


END;

/
--------------------------------------------------------
--  DDL for Type RESERVATIONS_NT
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."RESERVATIONS_NT" AS TABLE OF RESERVATION_T;

/
--------------------------------------------------------
--  DDL for Type RESERVATION_T
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."RESERVATION_T" AS OBJECT (
    reservation_id NUMBER,
    guest REF CUSTOMER_T,
    roommates GUESTS_VARRAY,
    room_number NUMBER,
    reservation_time RESERVATION_TIME_T,
    status VARCHAR2(20),
    
    MEMBER PROCEDURE set_room_number(v_room_number IN NUMBER),
    MEMBER PROCEDURE set_reservation_status(v_status IN VARCHAR2),
    MEMBER PROCEDURE set_reservation_time(v_reservation_time IN RESERVATION_TIME_T),
    CONSTRUCTOR FUNCTION RESERVATION_T(
        v_room_number IN NUMBER,
        v_guest IN REF CUSTOMER_T,
        v_roommates GUESTS_VARRAY,
        v_reservation_time IN RESERVATION_TIME_T,
        v_status IN VARCHAR2
    ) RETURN SELF AS RESULT
);
/
CREATE OR REPLACE TYPE BODY "MATI"."RESERVATION_T" AS

    CONSTRUCTOR FUNCTION RESERVATION_T(
        v_room_number IN NUMBER,
        v_guest IN REF CUSTOMER_T,
        v_roommates GUESTS_VARRAY,
        v_reservation_time IN RESERVATION_TIME_T,
        v_status IN VARCHAR2
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.reservation_id := seq_reservation.nextval;
        SELF.guest := v_guest;
        SELF.room_number := v_room_number;
        SELF.reservation_time := v_reservation_time;
        SELF.status := v_status;

        IF v_roommates is NULL THEN
            SELF.roommates := GUESTS_VARRAY();
        ELSE
            SELF.roommates := v_roommates;
        END IF;
        RETURN;
    END;

    MEMBER PROCEDURE set_room_number(v_room_number IN NUMBER) IS
    BEGIN
        self.room_number := v_room_number;
    END set_room_number;    


    MEMBER PROCEDURE set_reservation_status(v_status IN VARCHAR2) IS
    BEGIN
        self.status := v_status;
    END set_reservation_status;


    MEMBER PROCEDURE set_reservation_time(v_reservation_time IN RESERVATION_TIME_T) IS
    BEGIN
        self.reservation_time := self.reservation_time;
    END set_reservation_time;

END;

/
--------------------------------------------------------
--  DDL for Type RESERVATION_TIME_T
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."RESERVATION_TIME_T" AS OBJECT (
    start_date DATE,
    end_date DATE
);

/
--------------------------------------------------------
--  DDL for Type ROOMS_NT
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."ROOMS_NT" AS TABLE OF ROOM_T;

/
--------------------------------------------------------
--  DDL for Type ROOM_T
--------------------------------------------------------

  CREATE OR REPLACE TYPE "MATI"."ROOM_T" AS OBJECT (
    room_number NUMBER,
    room_capacity NUMBER,
    price_per_night NUMBER(10,2),
    
    MEMBER PROCEDURE set_room_number(new_room_number IN NUMBER),
    MEMBER PROCEDURE set_room_capacity(new_capacity IN NUMBER),
    MEMBER PROCEDURE set_price(new_price IN NUMBER)
);
/
CREATE OR REPLACE TYPE BODY "MATI"."ROOM_T" AS

    MEMBER PROCEDURE set_room_number(new_room_number IN NUMBER) AS
    BEGIN
        self.room_number := new_room_number;
    END set_room_number;

    MEMBER PROCEDURE set_room_capacity(new_capacity IN NUMBER) AS
    BEGIN
        self.room_capacity := new_capacity;
    END set_room_capacity;

    MEMBER PROCEDURE set_price(new_price IN NUMBER) AS
    BEGIN
        self.price_per_night := new_price;
    END set_price;

END;

/
--------------------------------------------------------
--  DDL for Sequence SEQ_ADDR
--------------------------------------------------------

   CREATE SEQUENCE  "MATI"."SEQ_ADDR"  MINVALUE 1 MAXVALUE 99999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_CUSTOMER
--------------------------------------------------------

   CREATE SEQUENCE  "MATI"."SEQ_CUSTOMER"  MINVALUE 1 MAXVALUE 99999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_EMP
--------------------------------------------------------

   CREATE SEQUENCE  "MATI"."SEQ_EMP"  MINVALUE 1 MAXVALUE 99999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_HOTEL
--------------------------------------------------------

   CREATE SEQUENCE  "MATI"."SEQ_HOTEL"  MINVALUE 1 MAXVALUE 99999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_RESERVATION
--------------------------------------------------------

   CREATE SEQUENCE  "MATI"."SEQ_RESERVATION"  MINVALUE 1 MAXVALUE 99999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Table ADDRESS_OT
--------------------------------------------------------

  CREATE TABLE "MATI"."ADDRESS_OT" OF "MATI"."ADDRESS_T" 
 OIDINDEX  ( PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" ) 
 PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" ;
--------------------------------------------------------
--  DDL for Table CUSTOMER_OT
--------------------------------------------------------

  CREATE TABLE "MATI"."CUSTOMER_OT" OF "MATI"."CUSTOMER_T" 
 OIDINDEX  ( PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" ) 
 PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" ;
--------------------------------------------------------
--  DDL for Table EMPS_OT
--------------------------------------------------------

  CREATE TABLE "MATI"."EMPS_OT" OF "MATI"."EMPLOYEE_T" 
 OIDINDEX  ( PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" ) 
 PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" ;
--------------------------------------------------------
--  DDL for Table HOTELS
--------------------------------------------------------

  CREATE TABLE "MATI"."HOTELS" OF "MATI"."HOTEL_T" 
 OIDINDEX  ( PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" ) 
 PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" 
 NESTED TABLE "ROOMS" STORE AS "ROOMS_S"
 (PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" ) RETURN AS VALUE
 NESTED TABLE "RESERVATIONS" STORE AS "RESERVATIONS_S"
 (PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL" ) RETURN AS VALUE;
REM INSERTING into MATI.ADDRESS_OT
SET DEFINE OFF;
Insert into MATI.ADDRESS_OT (ADDRESS_ID,CITY,STREET,APARTMENT_NUMBER) values ('1','£Ûdü','al. Politechniki','3B');
Insert into MATI.ADDRESS_OT (ADDRESS_ID,CITY,STREET,APARTMENT_NUMBER) values ('2','Opoczno','ul. Skalna','21/36');
REM INSERTING into MATI.CUSTOMER_OT
SET DEFINE OFF;
Insert into MATI.CUSTOMER_OT (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,EMAIL_ADDRESS,PHONE_NUMBER) values ('1','Mateusz','Jurek','MATI.ADDRESS_T(1, ''£Ûdü'', ''al. Politechniki'', ''3B'')','matu@mail.com','553-123-123');
Insert into MATI.CUSTOMER_OT (CUSTOMER_ID,FIRST_NAME,LAST_NAME,ADDRESS,EMAIL_ADDRESS,PHONE_NUMBER) values ('2','Arkadiusz','Sa≥aj','MATI.ADDRESS_T(2, ''Opoczno'', ''ul. Skalna'', ''21/36'')','arek@mail.com','222-333-444');
REM INSERTING into MATI.EMPS_OT
SET DEFINE OFF;
REM INSERTING into MATI.HOTELS
SET DEFINE OFF;
Insert into MATI.HOTELS (HOTEL_ID,NAME,STAR_RATING,ROOMS,RESERVATIONS) values ('4','PLAZA','0',MATI.ROOMS_NT(MATI.ROOM_T(101, 1, 100), MATI.ROOM_T(102, 2, 200), MATI.ROOM_T(103, 3, 300), MATI.ROOM_T(104, 4, 400)),MATI.RESERVATIONS_NT(MATI.RESERVATION_T(4, 'oracle.sql.REF@15311631', MATI.GUESTS_VARRAY(2), 103, MATI.RESERVATION_TIME_T('2024-02-08 00:00:00.0', '2024-02-09 00:00:00.0'), 'CANCELED'), MATI.RESERVATION_T(6, 'oracle.sql.REF@15311631', MATI.GUESTS_VARRAY(2), 102, MATI.RESERVATION_TIME_T('2024-02-08 00:00:00.0', '2024-02-09 00:00:00.0'), 'Active')));
--------------------------------------------------------
--  DDL for Trigger TR_EMPS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "MATI"."TR_EMPS" 
BEFORE INSERT ON EMPS_OT 
FOR EACH ROW 
BEGIN
    :NEW.job := UPPER(:NEW.job);
END;
/
ALTER TRIGGER "MATI"."TR_EMPS" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TR_NEW_HOTEL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "MATI"."TR_NEW_HOTEL" 
BEFORE INSERT ON HOTELS 
FOR EACH ROW 
BEGIN
    :NEW.hotel_id := SEQ_HOTEL.nextval;
    :NEW.star_rating := 0;
END;
/
ALTER TRIGGER "MATI"."TR_NEW_HOTEL" ENABLE;
--------------------------------------------------------
--  DDL for Package CUSTOMER_MANAGER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "MATI"."CUSTOMER_MANAGER" AS 

    PROCEDURE display_customer_info(v_customer_id IN NUMBER);
    PROCEDURE display_all_customers_info;
    PROCEDURE display_customer_reservations(v_hotel IN HOTEL_T, v_customer_id IN NUMBER);

    FUNCTION does_customer_exists(v_customer IN CUSTOMER_T) RETURN BOOLEAN;
    FUNCTION add_customer(v_customer IN CUSTOMER_T) RETURN NUMBER;
    FUNCTION get_customer_ref(v_id IN NUMBER) RETURN REF CUSTOMER_T;

    FUNCTION does_address_exists(v_address IN ADDRESS_T) RETURN NUMBER;
    FUNCTION add_new_address(v_address IN ADDRESS_T) RETURN REF ADDRESS_T;

    PROCEDURE set_customer_informations(
        v_customer_id IN NUMBER,
        v_new_address IN REF ADDRESS_T,
        v_new_email_address IN VARCHAR2,
        v_new_phone_number IN VARCHAR2
    );

END CUSTOMER_MANAGER;

/
--------------------------------------------------------
--  DDL for Package HOTEL_MANAGER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "MATI"."HOTEL_MANAGER" AS 

    FUNCTION create_hotel(v_name IN HOTELS.name%TYPE) RETURN NUMBER; 
    PROCEDURE set_hotel_stars(v_hotel IN HOTEL_T, v_stars IN NUMBER);
    PROCEDURE set_hotel_name(v_hotel IN HOTEL_T, new_name IN VARCHAR2);

    PROCEDURE add_employee(v_hotel IN HOTEL_T, v_emp IN EMPLOYEE_T);
    PROCEDURE delete_employee(v_hotel IN HOTEL_T, v_emp_id IN NUMBER);

    PROCEDURE add_room(v_hotel IN HOTEL_T, v_room IN ROOM_T);
    PROCEDURE delete_room(v_hotel IN HOTEL_T, v_room_number IN NUMBER);

END HOTEL_MANAGER;

/
--------------------------------------------------------
--  DDL for Package RESERVATION_MANAGER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "MATI"."RESERVATION_MANAGER" AS 

    TYPE REF_CURSOR_T IS REF CURSOR;

    PROCEDURE add_reservation(v_hotel IN HOTEL_T, v_reservation IN RESERVATION_T);
    PROCEDURE display_all_reservations_info(v_hotel IN HOTEL_T);      
    PROCEDURE display_reservation_info(v_hotel IN HOTEL_T, v_reservation_id IN NUMBER);
    PROCEDURE display_reservations_by_status(v_hotel IN HOTEL_T, v_status IN VARCHAR2);
    PROCEDURE display_reservations_by_date(v_hotel IN HOTEL_T, v_date IN DATE);

    PROCEDURE set_reservation_informations(
        v_hotel IN HOTEL_T,
        v_reservation_id IN NUMBER,
        v_new_room_number IN NUMBER,
        v_new_reservation_date IN RESERVATION_TIME_T,
        v_new_status IN VARCHAR2
    );

    FUNCTION does_reservation_exists(v_hotel IN HOTEL_T, v_reservation_id IN NUMBER) RETURN BOOLEAN;
    FUNCTION prepare_roommates_varray(v_id_1 NUMBER, v_id_2 NUMBER, v_id_3 NUMBER) RETURN GUESTS_VARRAY; 

END RESERVATION_MANAGER;

/
--------------------------------------------------------
--  DDL for Package ROOM_MANAGER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "MATI"."ROOM_MANAGER" AS 

    PROCEDURE display_free_rooms_in_dates(v_hotel IN HOTEL_T, v_time IN RESERVATION_TIME_T, v_min_capacity NUMBER);
    FUNCTION does_room_exists(v_hotel IN HOTEL_T, v_room_number IN NUMBER) RETURN BOOLEAN;
    FUNCTION is_room_free_between_dates(v_hotel IN HOTEL_T, v_room_number IN NUMBER, v_time IN RESERVATION_TIME_T) RETURN BOOLEAN;

    PROCEDURE get_all_reservations_for_room(
        v_hotel IN HOTEL_T, 
        v_room_nr IN NUMBER,
        v_ref_cursor IN OUT RESERVATION_MANAGER.REF_CURSOR_T
    );

    PROCEDURE get_room_reservations_dates(
        v_hotel IN HOTEL_T, 
        v_room_nr IN NUMBER,
        v_ref_cursor IN OUT RESERVATION_MANAGER.REF_CURSOR_T
    );

    PROCEDURE set_room_informations(
        v_hotel IN HOTEL_T, 
        v_room_number IN NUMBER, 
        v_new_room_number IN NUMBER,
        v_new_room_capacity IN NUMBER,
        v_new_room_price IN NUMBER
    );

    PROCEDURE display_all_rooms_info(v_hotel IN HOTEL_T, with_reservations IN BOOLEAN);
    PROCEDURE display_rooms_by_capacity(v_hotel IN HOTEL_T, v_room_capacity IN NUMBER, with_reservations IN BOOLEAN);
    PROCEDURE display_rooms_below_price(v_hotel IN HOTEL_T, v_room_price IN NUMBER, with_reservations IN BOOLEAN);
    PROCEDURE display_rooms_above_price(v_hotel IN HOTEL_T, v_room_price IN NUMBER, with_reservations IN BOOLEAN);
    PROCEDURE display_room_info(v_hotel IN HOTEL_T, v_room_number IN NUMBER, with_reservations IN BOOLEAN);



END ROOM_MANAGER;

/
--------------------------------------------------------
--  DDL for Package UTILS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "MATI"."UTILS" AS 

    FUNCTION get_hotel(v_id IN NUMBER) RETURN HOTEL_T;
    FUNCTION get_hotel_ref(v_id IN NUMBER) RETURN REF HOTEL_T;

    PROCEDURE display_all_hotels;

END UTILS;

/
--------------------------------------------------------
--  DDL for Package Body CUSTOMER_MANAGER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "MATI"."CUSTOMER_MANAGER" AS

    PROCEDURE display_customer_reservations(v_hotel IN HOTEL_T, 
    v_customer_id IN NUMBER) IS
        v_flag NUMBER;
        v_id NUMBER;

        CURSOR v_cursor IS SELECT r.reservation_id FROM TABLE(v_hotel.reservations) r
            WHERE deref(r.guest).customer_id = v_customer_id;
    BEGIN

        IF v_hotel is null OR v_customer_id is null OR v_customer_id < 0 THEN
            raise_application_error(-20001, 'Incorrect input!');
            NULL;
        END IF;

        SELECT COUNT(*) INTO v_flag FROM CUSTOMER_OT WHERE customer_id = v_customer_id;

        IF v_flag = 0 THEN
            raise_application_error(-20002, 'Customer with given ID does not exists!');
            NULL;
        END IF;
        DBMS_OUTPUT.PUT_LINE('[CUSTOMER RESERVATIONS]');

        OPEN v_cursor;
        LOOP
            FETCH v_cursor INTO v_id;
            EXIT WHEN v_cursor%NOTFOUND;
            RESERVATION_MANAGER.display_reservation_info(v_hotel, v_id);
        END LOOP;
        CLOSE v_cursor;

    END display_customer_reservations;

-- #############################################################################

    FUNCTION does_customer_exists(v_customer IN CUSTOMER_T) RETURN BOOLEAN IS
        v_flag NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_flag FROM CUSTOMER_OT c 
        WHERE 
            LOWER(v_customer.first_name) = LOWER(c.first_name) AND
            LOWER(v_customer.last_name) = LOWER(c.last_name) AND
            LOWER(v_customer.phone_number) = LOWER(c.phone_number);

        IF v_flag > 0 THEN
            RETURN True;
        ELSE
            RETURN False;
        END IF;

    END does_customer_exists;

-- #############################################################################

    FUNCTION add_customer(v_customer IN CUSTOMER_T) RETURN NUMBER IS
        v_status BOOLEAN;
        v_id NUMBER;
    BEGIN

        IF v_customer is null OR v_customer.first_name is null or v_customer.last_name is null or
            v_customer.address is null or v_customer.phone_number is null THEN
                raise_application_error(-20001, 'Incorrect input!');
                RETURN NULL;
        END IF; 

        v_status := does_customer_exists(v_customer);

        IF v_status = True THEN
            SELECT c.customer_id INTO v_id FROM CUSTOMER_OT c 
            WHERE c.customer_id = v_customer.customer_id;

            RETURN v_id;
        END IF;

        insert into CUSTOMER_OT VALUES (v_customer);
        select c.customer_id into v_id from CUSTOMER_OT c where c.customer_id = v_customer.customer_id;
        RETURN v_id;

    END add_customer;

-- #############################################################################

    PROCEDURE set_customer_informations(
        v_customer_id IN NUMBER,
        v_new_address IN REF ADDRESS_T,
        v_new_email_address IN VARCHAR2,
        v_new_phone_number IN VARCHAR2) AS

        v_customer CUSTOMER_T;
        v_check NUMBER;
    BEGIN
        IF v_customer_id IS NULL THEN
            raise_application_error(-20001, 'Incorrect input!');
        END IF;

        SELECT COUNT(*) INTO v_check FROM CUSTOMER_OT WHERE customer_id = v_customer_id;

        IF v_check = 0 THEN
            raise_application_error(-20002, 'Customer with given ID does not exist!');
        END IF;

        IF v_new_address IS NOT NULL THEN
            UPDATE CUSTOMER_OT SET address = v_new_address WHERE customer_id = v_customer_id;
        END IF;

        IF v_new_email_address IS NOT NULL THEN
            UPDATE CUSTOMER_OT SET email_address = v_new_email_address WHERE customer_id = v_customer_id;
        END IF;

        IF v_new_phone_number IS NOT NULL THEN
            UPDATE CUSTOMER_OT SET phone_number = v_new_phone_number WHERE customer_id = v_customer_id;
        END IF;
    END set_customer_informations;

-- #############################################################################

    PROCEDURE display_customer_info(v_customer_id IN NUMBER) AS
        v_ref REF CUSTOMER_T;
        v_customer CUSTOMER_T;
        v_address ADDRESS_T;
        v_check NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_check FROM CUSTOMER_OT WHERE customer_id = v_customer_id;
        IF v_check = 1 THEN
            SELECT ref(c) INTO v_ref FROM CUSTOMER_OT c WHERE customer_id = v_customer_id;
            SELECT deref(v_ref) INTO v_customer FROM dual;
            SELECT deref(v_customer.address) INTO v_address FROM dual;
            DBMS_OUTPUT.PUT_LINE(
                '#ID: ' || v_customer.customer_id || 
                ' | First name: ' || v_customer.first_name ||
                ' | Last name: ' || v_customer.last_name ||
                ' | Address: ' || v_address.city || ' ' || v_address.street || ' ' || v_address.apartment_number ||
                ' | Email address: ' || v_customer.email_address ||
                ' | Phone number: ' || v_customer.phone_number);
        ELSE
            DBMS_OUTPUT.PUT_LINE('#Customer with given ID does not exists!');
        END IF;
    END display_customer_info;

-- #############################################################################

    PROCEDURE display_all_customers_info AS
        v_id NUMBER;
        v_first_name VARCHAR2(50);
        v_last_name VARCHAR2(50);
        v_ref REF ADDRESS_T;
        v_email VARCHAR2(50);
        v_phone VARCHAR2(50);
        v_address ADDRESS_T;
        CURSOR cur IS SELECT r.* FROM CUSTOMER_OT r;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('[CUSTOMERS INFO]');
        OPEN cur;
        LOOP
            FETCH cur INTO v_id, v_first_name, v_last_name, v_ref, v_email, v_phone;
            EXIT WHEN cur%NOTFOUND;
            SELECT deref(v_ref) INTO v_address FROM dual;
            DBMS_OUTPUT.PUT_LINE(
                '#ID: ' || v_id || 
                ' | First name: ' || v_first_name ||
                ' | Last name: ' || v_last_name ||
                ' | Address: ' || v_address.city || ' ' || v_address.street || ' ' || v_address.apartment_number ||
                ' | Email address: ' || v_email ||
                ' | Phone number: ' || v_phone);
        END LOOP;
        CLOSE cur;

    END display_all_customers_info;

-- #############################################################################

    FUNCTION does_address_exists(v_address IN ADDRESS_T) RETURN NUMBER IS
        v_flag NUMBER;
        v_street VARCHAR2(50);
        v_id NUMBER;
    BEGIN

        SELECT COUNT(*) INTO v_flag FROM ADDRESS_OT a 
        WHERE 
            LOWER(v_address.city) = LOWER(a.city) AND
            LOWER(v_address.apartment_number) = LOWER(a.apartment_number) AND
            LOWER(v_address.street) = LOWER(a.street);

        IF v_flag > 0 THEN

            SELECT a.address_id INTO v_id FROM ADDRESS_OT a 
            WHERE 
                LOWER(v_address.city) = LOWER(a.city) AND
                LOWER(v_address.apartment_number) = LOWER(a.apartment_number) AND
                LOWER(v_address.street) = LOWER(a.street); 

            RETURN v_id;
        ELSE
            RETURN NULL;
        END IF;

    END;

-- #############################################################################

    FUNCTION add_new_address(v_address IN ADDRESS_T) RETURN REF ADDRESS_T IS
        v_addr_ref REF ADDRESS_T;
        v_existed_id NUMBER;
    BEGIN

        IF v_address IS NULL OR
            v_address.street is NULL OR
            v_address.city is NULL OR
            v_address.apartment_number is NULL
        THEN
            raise_application_error(-20001, 'Incorrect input!');
            RETURN NULL;
        END IF;

        v_existed_id := does_address_exists(v_address);

        IF v_existed_id is not null THEN
            select ref(a) into v_addr_ref from ADDRESS_OT a 
            where a.address_id = v_existed_id;    
        ELSE
            insert into ADDRESS_OT VALUES(v_address);

            select ref(a) into v_addr_ref from ADDRESS_OT a 
            where a.address_id = v_address.address_id;
        END IF;

        RETURN v_addr_ref;

    END add_new_address;

-- ############################################################################# 

    FUNCTION get_customer_ref(v_id IN NUMBER) RETURN REF CUSTOMER_T IS
        v_cust_ref REF CUSTOMER_T;
        v_flag NUMBER;
    BEGIN
        IF v_id is null THEN
            raise_application_error(-20001, 'Incorrect input!');
        END IF;

        select count(*) into v_flag from CUSTOMER_OT c where c.customer_id = v_id;

        IF v_flag = 0 THEN
            raise_application_error(-20002, 'Customer with given ID does not exists!');
        END IF;

        SELECT ref(c) into v_cust_ref FROM CUSTOMER_OT c WHERE c.customer_id = v_id;

        RETURN v_cust_ref;

    END get_customer_ref;


END CUSTOMER_MANAGER;

/
--------------------------------------------------------
--  DDL for Package Body HOTEL_MANAGER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "MATI"."HOTEL_MANAGER" AS

    PROCEDURE add_employee(v_hotel IN HOTEL_T, v_emp IN EMPLOYEE_T) IS
        v_emp_cpy EMPLOYEE_T;
    BEGIN

        IF 
        v_hotel is null OR
        v_emp is null OR
        v_emp.first_name is null OR
        v_emp.last_name is null OR
        v_emp.job is null OR
        v_emp.salary is null OR
        v_emp.salary < 0 OR
        v_emp.hire_date is null
        THEN
            raise_application_error(-20001, 'Incorrect input!');
            NULL;
        END IF;

        v_emp_cpy := v_emp;

        v_emp_cpy.emp_id := seq_emp.nextval;
        v_emp_cpy.hotel_id := v_hotel.hotel_id;

        insert into EMPS_OT values (v_emp_cpy);

    END add_employee;

-- #############################################################################

    PROCEDURE delete_employee(v_hotel IN HOTEL_T, v_emp_id IN NUMBER) IS
        v_flag NUMBER;
    BEGIN
        IF v_hotel is null OR v_emp_id is null THEN
            raise_application_error(-20001, 'Incorrect input!');
            NULL;
        END IF;

        select count(*) into v_flag from EMPS_OT where emp_id = v_emp_id;

        IF v_flag = 0 THEN
            raise_application_error(-20002, 'Employee with given ID does not exists!');
            NULL;  
        END IF;

        delete from EMPS_OT where emp_id = v_emp_id;

    END;

-- ############################################################################# 

    FUNCTION create_hotel(v_name IN HOTELS.name%TYPE) RETURN NUMBER IS
        v_flag NUMBER;
        v_id NUMBER;
    BEGIN

        IF v_name IS NULL THEN
            raise_application_error(-20001, 'Incorrect input!');
            RETURN NULL;
        END IF;

        SELECT COUNT(*) INTO v_flag FROM HOTELS WHERE LOWER(name) = LOWER(v_name);
        IF v_flag > 0 THEN
            raise_application_error(-20003, 'Hotel with given name already exists!');
            RETURN NULL;
        END IF;


        insert into HOTELS (name, rooms, reservations) 
            VALUES (UPPER(v_name), ROOMS_NT(), RESERVATIONS_NT());

        RETURN seq_hotel.currval;
--        select h.hotel_id into v_id from HOTELS h where h.name = v_name; 

        RETURN v_id;

    END create_hotel;

-- #############################################################################

    PROCEDURE set_hotel_stars(v_hotel IN HOTEL_T, v_stars IN NUMBER) IS
        v_ref REF HOTEL_T;
    BEGIN

        IF v_hotel is null OR v_stars is null OR v_stars < 0 OR v_stars > 5 THEN
            raise_application_error(-20001, 'Incorrect input!');
            NULL;
        END IF;

        UPDATE HOTELS h SET h.star_rating = v_stars WHERE h.hotel_id = v_hotel.hotel_id;

    END set_hotel_stars;

-- #############################################################################

    PROCEDURE set_hotel_name(v_hotel IN HOTEL_T, new_name IN VARCHAR2) IS
        v_flag NUMBER;
    BEGIN

        IF v_hotel is null THEN
            raise_application_error(-20001, 'Incorrect input!');
            NULL;
        END IF;

        SELECT COUNT(*) INTO v_flag FROM HOTELS WHERE LOWER(name) = LOWER(new_name);
        IF v_flag > 0 THEN
            raise_application_error(-20003, 'Hotel with given name already exists!');
            NULL;
        END IF;    

        UPDATE HOTELS SET name = UPPER(new_name) WHERE hotel_id = v_hotel.hotel_id;

    END set_hotel_name;

-- #############################################################################

    PROCEDURE add_room(v_hotel IN HOTEL_T, v_room IN ROOM_T) AS
    BEGIN
        IF v_hotel IS NULL THEN
            raise_application_error(-20001, 'Incorrect input!');
        END IF;

        IF v_room IS NULL OR
        v_room.room_capacity <= 0 OR
        v_room.price_per_night <=0 THEN
            raise_application_error(-20001, 'Incorrect input! Room object is not correctly filled');
        END IF;

        IF ROOM_MANAGER.does_room_exists(v_hotel, v_room.room_number) = TRUE THEN
            raise_application_error(-20003, 'Room with given room number already exists!');
        END IF;

        INSERT INTO 
        table(select rooms from HOTELS h WHERE h.hotel_id = v_hotel.hotel_id) 
            values (v_room);
    END add_room;

-- #############################################################################

    PROCEDURE delete_room(v_hotel IN HOTEL_T, v_room_number IN NUMBER) AS
        v_ref_cursor RESERVATION_MANAGER.REF_CURSOR_T;
        v_are_active_reservations BOOLEAN := FALSE;
        v_time RESERVATION_TIME_T;
    BEGIN
        IF v_hotel IS null or v_room_number is null THEN
            raise_application_error(-20001, 'Incorrect input!');
            NULL;
        END IF;

        IF ROOM_MANAGER.does_room_exists(v_hotel, v_room_number) = False THEN
            raise_application_error(-20002, 'Room with given number does not exists!');
            NULL;
        END IF;

        ROOM_MANAGER.get_room_reservations_dates(v_hotel, v_room_number, v_ref_cursor);

        LOOP
            FETCH v_ref_cursor INTO v_time;
            EXIT WHEN v_ref_cursor%NOTFOUND;

            v_are_active_reservations := True;
            EXIT;

        END LOOP;    

        CLOSE v_ref_cursor;

        IF v_are_active_reservations = True THEN
            raise_application_error(-20003, 'Room has active reservation!');
            NULL;
        END IF;

        DELETE FROM 
            table(select rooms from HOTELS h WHERE h.hotel_id = v_hotel.hotel_id) r 
        WHERE r.room_number = v_room_number;

    END delete_room;

END HOTEL_MANAGER;

/
--------------------------------------------------------
--  DDL for Package Body RESERVATION_MANAGER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "MATI"."RESERVATION_MANAGER" AS

    PROCEDURE display_reservations_by_date(v_hotel IN HOTEL_T, v_date IN DATE) IS
        v_id NUMBER;

        CURSOR v_cursor IS SELECT r.reservation_id FROM TABLE(v_hotel.reservations) r
            WHERE TRUNC(v_date) >= TRUNC(r.reservation_time.start_date) AND
                  TRUNC(v_date) <= TRUNC(r.reservation_time.end_date);
    BEGIN

        IF v_hotel is null OR v_date is null THEN
            raise_application_error(-20001, 'Incorrect input!');
            NULL;
        END IF;

        DBMS_OUTPUT.PUT_LINE('[Reservations dated ' || TRUNC(v_date) || ']');

        OPEN v_cursor;
        LOOP
            FETCH v_cursor INTO v_id;
            EXIT WHEN v_cursor%NOTFOUND;
            RESERVATION_MANAGER.display_reservation_info(v_hotel, v_id);
        END LOOP;
        CLOSE v_cursor;    

    END display_reservations_by_date;

-- #############################################################################

    PROCEDURE add_reservation(v_hotel IN HOTEL_T, v_reservation IN RESERVATION_T) AS
        v_room_size NUMBER;
        v_deref_guest CUSTOMER_T;
    BEGIN
        IF v_hotel IS NULL THEN
            raise_application_error(-20001, 'Incorrect input!');
        END IF;

        IF v_reservation IS NULL OR  
        v_reservation.roommates IS NULL OR
        v_reservation.guest IS NULL OR
        v_reservation.room_number IS NULL OR 
        v_reservation.reservation_time IS NULL OR
        v_reservation.reservation_time.start_date is NULL OR
        v_reservation.reservation_time.end_date is NULL OR
        v_reservation.status IS NULL THEN
            raise_application_error(-20001, 'Incorrect input! Reservation object is not correctly filled.');
        END IF;

        IF ROOM_MANAGER.does_room_exists(v_hotel, v_reservation.room_number) = FALSE THEN
            raise_application_error(-20002, 'Room with given room number does not exists!');
        END IF;

        IF v_reservation.reservation_time.start_date < TRUNC(SYSDATE) THEN
            raise_application_error(-20001, 'Start date is less than current date!');
        END IF;

        IF ROOM_MANAGER.is_room_free_between_dates(v_hotel, v_reservation.room_number, v_reservation.reservation_time) = FALSE THEN
            raise_application_error(-20003, 'Cannot to make reservation this date.');
        END IF;

        SELECT r.room_capacity INTO v_room_size FROM TABLE(v_hotel.rooms) r WHERE r.room_number = v_reservation.room_number;

        IF v_room_size < v_reservation.roommates.COUNT+1 THEN
            raise_application_error(-20003, 'Room is too small for this reservation.');
        END IF;

        select deref(v_reservation.guest) into v_deref_guest from dual;

        FOR i IN 1..v_reservation.roommates.COUNT LOOP
            IF v_reservation.roommates(i) = v_deref_guest.customer_id THEN
                raise_application_error(-20003, 'Person who make reservation cannot by roommate same time!');
            END IF;
        END LOOP;

        INSERT INTO 
            table(select reservations from HOTELS h WHERE h.hotel_id = v_hotel.hotel_id) 
            values (v_reservation);

    END add_reservation;

-- #############################################################################

    FUNCTION does_reservation_exists(v_hotel IN HOTEL_T, v_reservation_id IN NUMBER) 
    RETURN BOOLEAN IS 
        v_reservations RESERVATIONS_NT;
    BEGIN

        IF v_hotel IS NULL OR v_reservation_id IS NULL OR v_reservation_id < 0 THEN
            raise_application_error(-20001, 'Incorrect input!');
            RETURN NULL;
        END IF;

        SELECT v_hotel.reservations INTO v_reservations FROM dual;        

        FOR i IN 1..v_reservations.COUNT LOOP
            IF v_reservations(i).reservation_id = v_reservation_id THEN
                RETURN TRUE;
            END IF;
        END LOOP;

        RETURN FALSE;

    END does_reservation_exists;

-- #############################################################################

    PROCEDURE set_reservation_informations(
        v_hotel IN HOTEL_T,
        v_reservation_id IN NUMBER,
        v_new_room_number IN NUMBER,
        v_new_reservation_date IN RESERVATION_TIME_T,
        v_new_status IN VARCHAR2
    ) 
    AS
        v_reservations RESERVATIONS_NT;
        v_room_size NUMBER;
    BEGIN
        IF v_hotel IS NULL OR v_reservation_id IS NULL THEN
            raise_application_error(-20001, 'Incorrect input!');
        ELSIF RESERVATION_MANAGER.does_reservation_exists(v_hotel, v_reservation_id) = FALSE THEN
            raise_application_error(-20002, 'Reservation with given ID does not exist!');
        END IF;

        SELECT v_hotel.reservations INTO v_reservations FROM dual;  

        FOR i IN 1..v_reservations.COUNT LOOP
            IF v_reservations(i).reservation_id = v_reservation_id THEN

                IF v_new_room_number IS NOT NULL AND v_new_reservation_date IS NOT NULL THEN
                    IF ROOM_MANAGER.is_room_free_between_dates(v_hotel, v_new_room_number, v_new_reservation_date) = FALSE THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR: Cannot make reservation in room ' || v_reservations(i).room_number || ' for date [' || 
                        v_reservations(i).reservation_time.start_date || ' - ' || v_reservations(i).reservation_time.end_date || ']');
                        raise_application_error(-20003, 'Data conflict!');
                    END IF;
                    SELECT r.room_capacity INTO v_room_size FROM TABLE(v_hotel.rooms) r WHERE r.room_number = v_new_room_number;
                    IF v_room_size < v_reservations(i).roommates.COUNT+1 THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR: Cannot make reservation in room ' || v_new_room_number || ' for number of visitors: ' || 
                        (v_reservations(i).roommates.COUNT+1));
                        raise_application_error(-20003, 'Data conflict!');
                    END IF;
                    v_reservations(i).set_room_number(v_new_room_number);
                    v_reservations(i).set_reservation_time(v_new_reservation_date);
                END IF;

                IF v_new_room_number IS NULL AND v_new_reservation_date IS NOT NULL THEN
                    IF ROOM_MANAGER.is_room_free_between_dates(v_hotel, v_reservations(i).room_number, v_new_reservation_date) = FALSE THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR: Cannot make reservation in room ' || v_reservations(i).room_number || ' for date [' || 
                        v_reservations(i).reservation_time.start_date || ' - ' || v_reservations(i).reservation_time.end_date || ']');
                        raise_application_error(-20003, 'Data conflict!');
                    END IF;
                    v_reservations(i).set_reservation_time(v_new_reservation_date);
                END IF;

                IF v_new_room_number IS NOT NULL AND v_new_reservation_date IS NULL THEN
                    IF ROOM_MANAGER.is_room_free_between_dates(v_hotel, v_new_room_number, v_reservations(i).reservation_time) = FALSE THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR: Cannot make reservation in room ' || v_reservations(i).room_number || ' for date [' || 
                        v_reservations(i).reservation_time.start_date || ' - ' || v_reservations(i).reservation_time.end_date || ']');
                        raise_application_error(-20003, 'Data conflict!');
                    END IF;
                    SELECT r.room_capacity INTO v_room_size FROM TABLE(v_hotel.rooms) r WHERE r.room_number = v_new_room_number;
                    IF v_room_size < v_reservations(i).roommates.COUNT+1 THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR: Cannot make reservation in room ' || v_new_room_number || ' for number of visitors: ' || 
                        (v_reservations(i).roommates.COUNT+1));
                        raise_application_error(-20003, 'Data conflict!');
                    END IF;
                    v_reservations(i).set_room_number(v_new_room_number);
                END IF;

                IF v_new_status IS NOT NULL THEN
                    IF LOWER(v_new_status) <> 'active' AND LOWER(v_new_status) <> 'ended' AND LOWER(v_new_status) <> 'canceled' THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR: Given status is incorrect! (Active, Ended, Canceled) Your status: ' || v_new_status);
                        raise_application_error(-20001, 'Incorrect input!');
                    END IF;
                    v_reservations(i).set_reservation_status(UPPER(v_new_status));
                END IF;

                EXIT;

            END IF;
        END LOOP;
        UPDATE HOTELS SET reservations = v_reservations WHERE hotel_id = v_hotel.hotel_id;
    END set_reservation_informations;

-- #############################################################################

    PROCEDURE display_all_reservations_info(v_hotel IN HOTEL_T) AS
        CURSOR cur IS SELECT r.reservation_id FROM TABLE(v_hotel.reservations) r;
        v_id NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('[RESERVATIONS INFO]');
    OPEN cur;

    LOOP
        FETCH cur INTO v_id;
        EXIT WHEN cur%NOTFOUND;
        RESERVATION_MANAGER.display_reservation_info(v_hotel, v_id);
    END LOOP;

    CLOSE cur;

    END display_all_reservations_info;

-- #############################################################################

    PROCEDURE display_reservation_info(v_hotel IN HOTEL_T, v_reservation_id IN NUMBER) AS
        v_id NUMBER;
        v_roommates GUESTS_VARRAY;
        v_ref REF CUSTOMER_T;
        v_guest CUSTOMER_T;
        v_room_number NUMBER;
        v_reservation_time RESERVATION_TIME_T;
        v_status VARCHAR2(20);
    BEGIN
        IF v_hotel IS NULL OR v_reservation_id IS NULL OR v_reservation_id < 0 THEN
            raise_application_error(-20001, 'Incorrect input!');
            NULL;
        END IF;

        SELECT r.* INTO 
            v_id,
            v_ref,
            v_roommates,
            v_room_number,
            v_reservation_time,
            v_status
        FROM TABLE(v_hotel.reservations) r WHERE r.reservation_id = v_reservation_id;

        IF v_id is NULL THEN
            raise_application_error(-20002, 'Reservation with given ID does not exists!');
            NULL;
        END IF;

        SELECT deref(v_ref) INTO v_guest FROM dual;

        DBMS_OUTPUT.PUT_LINE(
        '#ID: ' || v_id || 
        ' | Status: ' || v_status ||
        ' | Date: [' || v_reservation_time.start_date || ' - ' || v_reservation_time.end_date ||
        '] | Room nr: ' || v_room_number ||
        ' | Visitors: ' || (v_roommates.COUNT+1) ||
        ' | Customer ID: ' || v_guest.customer_id || ' | Customer name: ' ||
        v_guest.first_name || ' ' || v_guest.last_name);
        IF v_roommates.COUNT > 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[ROOMMATES]');
            FOR i IN 1..v_roommates.COUNT LOOP
                CUSTOMER_MANAGER.display_customer_info(v_roommates(i));
            END LOOP;
        END IF;

    END display_reservation_info;

-- #############################################################################

    PROCEDURE display_reservations_by_status(v_hotel IN HOTEL_T, v_status IN VARCHAR2) AS
        CURSOR cur IS SELECT r.reservation_id FROM TABLE(v_hotel.reservations) r WHERE LOWER(r.status) = LOWER(v_status);
        v_id NUMBER;
    BEGIN
        IF v_status IS NULL THEN
            raise_application_error(-20001, 'Given status is null');
        END IF;
        IF LOWER(v_status) <> 'active' AND LOWER(v_status) <> 'ended' AND LOWER(v_status) <> 'canceled' THEN
            raise_application_error(-20001, 'Given status is incorrect');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[RESERVATIONS INFO BY STATUS: ' || v_status || ']');
    OPEN cur;

    LOOP
        FETCH cur INTO v_id;
        EXIT WHEN cur%NOTFOUND;
        RESERVATION_MANAGER.display_reservation_info(v_hotel, v_id);
    END LOOP;

    CLOSE cur;
    END display_reservations_by_status;

-- #############################################################################

    FUNCTION prepare_roommates_varray(v_id_1 NUMBER, v_id_2 NUMBER, v_id_3 NUMBER) 
    RETURN GUESTS_VARRAY IS
        v_id NUMBER;
        v_roommates GUESTS_VARRAY := GUESTS_VARRAY();

        v_flag_1 NUMBER;
        v_flag_2 NUMBER;
        v_flag_3 NUMBER;
    BEGIN



        IF v_id_1 is not null THEN
            IF v_id_1 = v_id_2 OR v_id_1 = v_id_3 THEN
                raise_application_error(-20003, 'Customers IDs cant be the same!');
            END IF;

            SELECT COUNT(*) INTO v_flag_1 FROM CUSTOMER_OT c WHERE c.customer_id = v_id_1; 
            IF v_flag_1 <> 0 THEN
                v_roommates.EXTEND;
                v_roommates(v_roommates.COUNT) := v_id_1;
            ELSE
                raise_application_error(-20002, 'Customer with given ID does not exists!');
            END IF;
        END IF;

        IF v_id_2 is not null THEN
            IF v_id_2 = v_id_1 OR v_id_2 = v_id_3 THEN
                raise_application_error(-20003, 'Customers IDs cant be the same!');
            END IF;

            SELECT COUNT(*) INTO v_flag_2 FROM CUSTOMER_OT c WHERE c.customer_id = v_id_2; 
            IF v_flag_2 <> 0 THEN
                v_roommates.EXTEND;
                v_roommates(v_roommates.COUNT) := v_id_2;
            ELSE
                raise_application_error(-20002, 'Customer with given ID does not exists!');
            END IF;
        END IF;

        IF v_id_3 is not null THEN
            IF v_id_3 = v_id_1 OR v_id_3 = v_id_2 THEN
                raise_application_error(-20003, 'Customers IDs cant be the same!');
            END IF;

            SELECT COUNT(*) INTO v_flag_3 FROM CUSTOMER_OT c WHERE c.customer_id = v_id_3; 
            IF v_flag_3 <> 0 THEN
                v_roommates.EXTEND;
                v_roommates(v_roommates.COUNT) := v_id_3;
            ELSE
                raise_application_error(-20002, 'Customer with given ID does not exists!');
            END IF;
        END IF;

        RETURN v_roommates;

    END prepare_roommates_varray;

-- #############################################################################



END RESERVATION_MANAGER;

/
--------------------------------------------------------
--  DDL for Package Body ROOM_MANAGER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "MATI"."ROOM_MANAGER" AS

    PROCEDURE display_free_rooms_in_dates(v_hotel IN HOTEL_T, v_time 
            IN RESERVATION_TIME_T, v_min_capacity NUMBER) IS
    
        v_rooms ROOMS_NT;
        v_nr NUMBER;
        v_status BOOLEAN;
        v_capacity NUMBER;
    BEGIN

        IF v_hotel is null OR v_time is null OR v_time.start_date is null OR 
            v_time.end_date is null OR TRUNC(v_time.start_date) >= TRUNC(v_time.end_date) OR 
            v_min_capacity is null OR v_min_capacity < 1
        THEN
            raise_application_error(-20001, 'Incorrect input!');
            NULL;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[FREE ROOMS IN TIME ' || v_time.start_date || ' - ' || v_time.end_date || ']');
        
        v_rooms := v_hotel.rooms;

        FOR i IN 1..v_rooms.COUNT LOOP
            v_nr := v_rooms(i).room_number;
            v_capacity := v_rooms(i).room_capacity;
            v_status := ROOM_MANAGER.is_room_free_between_dates(
                v_hotel, v_nr, v_time); 

            IF v_status = False OR v_capacity < v_min_capacity THEN
                CONTINUE;
            END IF;

            ROOM_MANAGER.display_room_info(v_hotel, v_nr, False);

        END LOOP;


    END display_free_rooms_in_dates;

-- #############################################################################

    FUNCTION does_room_exists(v_hotel IN HOTEL_T, v_room_number IN NUMBER) 
    RETURN BOOLEAN IS 
        v_rooms ROOMS_NT;
    BEGIN

        IF v_hotel IS NULL OR v_room_number IS NULL OR v_room_number < 0 THEN
            raise_application_error(-20001, 'Incorrect input!');
            RETURN NULL;
        END IF;

        SELECT v_hotel.rooms INTO v_rooms FROM dual;        

        FOR i IN 1..v_rooms.COUNT LOOP
            IF v_rooms(i).room_number = v_room_number THEN
                RETURN TRUE;
            END IF;
        END LOOP;

        RETURN FALSE;

    END does_room_exists;

-- #############################################################################

    FUNCTION is_room_free_between_dates(v_hotel IN HOTEL_T, v_room_number IN NUMBER, 
        v_time IN RESERVATION_TIME_T) RETURN BOOLEAN IS

        v_ref_cursor RESERVATION_MANAGER.REF_CURSOR_T;
        v_r_time RESERVATION_TIME_T;
        v_occupied BOOLEAN := False;

        v_start DATE;
        v_end DATE;
    BEGIN

        IF v_hotel is null OR v_room_number is NULL OR v_room_number < 0 OR
                v_time is null OR v_time.start_date is null OR 
                v_time.end_date is null OR TRUNC(v_time.end_date) <= TRUNC(v_time.start_date) 
            THEN
                raise_application_error(-20001, 'Incorrect input!');
                RETURN NULL;
        END IF;

        v_start := TRUNC(v_time.start_date);
        v_end := TRUNC(v_time.end_date);

--        IF v_start < TRUNC(SYSDATE) THEN
--            raise_application_error(-20001, 'Start date is less than current date!');
--            RETURN NULL;
--        END IF;

        IF does_room_exists(v_hotel, v_room_number) = False THEN
            raise_application_error(-20002, 'Room with given ID does not exists!');
            RETURN NULL;
        END IF;

        ROOM_MANAGER.get_room_reservations_dates(v_hotel, v_room_number, v_ref_cursor);

        LOOP
            FETCH v_ref_cursor INTO v_r_time;
            EXIT WHEN v_ref_cursor%NOTFOUND;

--            v_start   v_end      v_r_time.start_date   v_r_time.end_date

--            - jeøeli new_start jest pomiÍdzy old_start i old_end
--            - jeøeli new_end jest pomiÍdzy old_start i old_end
--            - jeøeli new_start < old_start  AND new_end > old_end


            IF v_start >= TRUNC(v_r_time.start_date) AND v_start < TRUNC(v_r_time.end_date) THEN
                RETURN False;
            END IF;

            IF v_end > TRUNC(v_r_time.start_date) AND v_end <= TRUNC(v_r_time.end_date) THEN
                RETURN False;
            END IF;

            IF v_start <= TRUNC(v_r_time.start_date) AND v_end >= TRUNC(v_r_time.end_date) THEN
                RETURN False;
            END IF;

        END LOOP;

        CLOSE v_ref_cursor;
        RETURN True;

    END is_room_free_between_dates;

-- #############################################################################

    PROCEDURE set_room_informations(
        v_hotel IN HOTEL_T, 
        v_room_number IN NUMBER, 
        v_new_room_number IN NUMBER,
        v_new_room_capacity IN NUMBER,
        v_new_room_price IN NUMBER) AS

        v_rooms ROOMS_NT;
    BEGIN 
        IF v_hotel IS NULL OR v_room_number IS NULL THEN
            raise_application_error(-20001, 'Incorrect input!');
        ELSIF ROOM_MANAGER.does_room_exists(v_hotel, v_room_number) = FALSE THEN
            raise_application_error(-20002, 'Room with given number does not exist!');
        END IF;

        SELECT v_hotel.rooms INTO v_rooms FROM dual;  

        FOR i IN 1..v_rooms.COUNT LOOP
            IF v_rooms(i).room_number = v_room_number THEN

                IF v_new_room_number IS NOT NULL AND ROOM_MANAGER.does_room_exists(v_hotel, v_new_room_number) = FALSE THEN
                    v_rooms(i).set_room_number(v_new_room_number);
                END IF;

                IF v_new_room_capacity IS NOT NULL AND v_new_room_capacity > 0  AND v_new_room_capacity < 5 THEN
                    v_rooms(i).set_room_capacity(v_new_room_capacity);
                END IF;

                IF v_new_room_price IS NOT NULL AND v_new_room_price > 0 THEN
                    v_rooms(i).set_price(v_new_room_price);
                END IF;

                EXIT;

            END IF;
        END LOOP;
        UPDATE HOTELS SET rooms = v_rooms WHERE hotel_id = v_hotel.hotel_id;

    END set_room_informations;

-- #############################################################################

    PROCEDURE display_all_rooms_info(v_hotel IN HOTEL_T, with_reservations IN BOOLEAN) IS
        CURSOR cur IS SELECT r.* FROM TABLE(v_hotel.rooms) r;
        nr NUMBER;
        price NUMBER;
        cap NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('[ROOMS INFO]');
    OPEN cur;

    LOOP
        FETCH cur INTO nr, cap, price;
        EXIT WHEN cur%NOTFOUND;
--        DBMS_OUTPUT.PUT_LINE('Nr: '||nr||' Price: '||price||'z≥ Capacity: '||cap);
        display_room_info(v_hotel, nr, with_reservations);
    END LOOP;

    CLOSE cur;

  END display_all_rooms_info;

-- #############################################################################

    PROCEDURE display_rooms_by_capacity(v_hotel IN HOTEL_T, v_room_capacity IN NUMBER, with_reservations IN BOOLEAN) AS

        v_rooms ROOMS_NT;
    BEGIN
        SELECT v_hotel.rooms INTO v_rooms FROM dual;  
        DBMS_OUTPUT.PUT_LINE('[ROOMS FILTERED BY CAPACITY >= ' || v_room_capacity || ']');
        FOR i IN 1..v_rooms.COUNT LOOP
            IF v_rooms(i).room_capacity >= v_room_capacity THEN
                ROOM_MANAGER.display_room_info(v_hotel, v_rooms(i).room_number, with_reservations);
            END IF;
        END LOOP;
    END display_rooms_by_capacity;

-- #############################################################################

    PROCEDURE display_rooms_below_price(v_hotel IN HOTEL_T, v_room_price IN NUMBER, with_reservations IN BOOLEAN) AS
        v_rooms ROOMS_NT;
    BEGIN
        SELECT v_hotel.rooms INTO v_rooms FROM dual;  
        DBMS_OUTPUT.PUT_LINE('ROOMS FILTERED BY BELOW PRICE ' || v_room_price || ' ZL]');
        FOR i IN 1..v_rooms.COUNT LOOP
            IF v_rooms(i).price_per_night <= v_room_price THEN
                ROOM_MANAGER.display_room_info(v_hotel, v_rooms(i).room_number, with_reservations);
            END IF;
        END LOOP;
    END display_rooms_below_price;

-- #############################################################################

    PROCEDURE display_rooms_above_price(v_hotel IN HOTEL_T, v_room_price IN NUMBER, with_reservations IN BOOLEAN) AS

        v_rooms ROOMS_NT;
    BEGIN
        SELECT v_hotel.rooms INTO v_rooms FROM dual;  
        DBMS_OUTPUT.PUT_LINE('[ROOMS FILTERED BY ABOVE PRICE ' || v_room_price || ' ZL]');
        FOR i IN 1..v_rooms.COUNT LOOP
            IF v_rooms(i).price_per_night >= v_room_price THEN
                ROOM_MANAGER.display_room_info(v_hotel, v_rooms(i).room_number, with_reservations);
            END IF;
        END LOOP;
    END display_rooms_above_price;

-- #############################################################################

    PROCEDURE display_room_info(v_hotel IN HOTEL_T, v_room_number IN NUMBER, with_reservations IN BOOLEAN) IS
        v_ref_cursor RESERVATION_MANAGER.REF_CURSOR_T;
        nr NUMBER;
        price NUMBER;
        cap NUMBER;

        v_time RESERVATION_TIME_T;
        v_guest REF CUSTOMER_T;

        v_r_id NUMBER;
        v_r_roommates GUESTS_VARRAY;
        v_r_guest REF CUSTOMER_T;
        v_r_room_nr NUMBER;
        v_r_time RESERVATION_TIME_T;
        v_r_status VARCHAR2(20);

    BEGIN

        IF v_hotel IS NULL OR v_room_number IS NULL THEN
            raise_application_error(-20001, 'Incorrect input!');
        ELSIF ROOM_MANAGER.does_room_exists(v_hotel, v_room_number) = FALSE THEN
            raise_application_error(-20002, 'Room with given number does not exist!');
        END IF; 

        get_all_reservations_for_room(v_hotel, v_room_number, v_ref_cursor);

        SELECT r.room_number, r.price_per_night, r.room_capacity
        INTO nr, price, cap
        FROM TABLE(v_hotel.rooms) r WHERE r.room_number = v_room_number;

        DBMS_OUTPUT.PUT_LINE('#Nr: '||nr||' | Price: '||price||'z≥ | Capacity: '||cap);
        IF with_reservations IS NOT NULL AND with_reservations = TRUE THEN
            DBMS_OUTPUT.PUT_LINE('Room active reservations:');
            LOOP
                FETCH v_ref_cursor INTO v_r_id, v_r_guest, v_r_roommates, v_r_room_nr, v_r_time, v_r_status;
                EXIT WHEN v_ref_cursor%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE('ID: '||v_r_id||' | Room nr: '||v_r_room_nr||' | Start: '||v_r_time.start_date||' | End: '||v_r_time.end_date||' | Status: '||v_r_status);
            END LOOP;
            DBMS_OUTPUT.NEW_LINE();
        END IF;
        CLOSE v_ref_cursor;


    END display_room_info;

-- #############################################################################

    PROCEDURE get_all_reservations_for_room(
        v_hotel IN HOTEL_T, 
        v_room_nr IN NUMBER,
        v_ref_cursor IN OUT RESERVATION_MANAGER.REF_CURSOR_T
    ) IS
    BEGIN

        IF v_hotel is null OR v_room_nr is null THEN
            raise_application_error(-20001, 'Incorrect input!');
            RETURN;            
        END IF;

        IF ROOM_MANAGER.does_room_exists(v_hotel, v_room_nr) = False THEN
            raise_application_error(-20002, 'Room with given number does not exists!');
            RETURN;
        END IF;

        OPEN v_ref_cursor FOR 
            SELECT r.* FROM TABLE(v_hotel.reservations) r 
            WHERE r.room_number = v_room_nr AND UPPER(r.status) = UPPER('Active');
    END get_all_reservations_for_room;

-- #############################################################################

    PROCEDURE get_room_reservations_dates(
        v_hotel IN HOTEL_T, 
        v_room_nr IN NUMBER,
        v_ref_cursor IN OUT RESERVATION_MANAGER.REF_CURSOR_T) IS
    BEGIN

        IF v_hotel is null OR v_room_nr is null THEN
            raise_application_error(-20001, 'Incorrect input!');
            RETURN;            
        END IF;

        IF ROOM_MANAGER.does_room_exists(v_hotel, v_room_nr) = False THEN
            raise_application_error(-20002, 'Room with given number does not exists!');
            RETURN;
        END IF;

        OPEN v_ref_cursor FOR 
            SELECT r.reservation_time FROM TABLE(v_hotel.reservations) r 
            WHERE r.room_number = v_room_nr AND r.status = 'Active';

    END get_room_reservations_dates;

-- #############################################################################



END ROOM_MANAGER;

/
--------------------------------------------------------
--  DDL for Package Body UTILS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "MATI"."UTILS" AS

    FUNCTION get_hotel(v_id IN NUMBER) RETURN HOTEL_T IS
        v_hotel HOTEL_T;
        v_ref REF HOTEL_T;
    BEGIN
        select ref(h) into v_ref from HOTELS h where h.hotel_id = v_id;
        select deref(v_ref) into v_hotel from dual;
        return v_hotel;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20002, 'Hotel with given ID does not exists!');
            RETURN NULL;

    END get_hotel;

-- #############################################################################

    FUNCTION get_hotel_ref(v_id IN NUMBER) RETURN REF HOTEL_T IS
        v_ref REF HOTEL_T;
        v_hotel HOTEL_T;
    BEGIN
        v_hotel := UTILS.get_hotel(v_id);
        select ref(h) into v_ref from HOTELS h WHERE h.hotel_id = v_hotel.hotel_id;
        RETURN v_ref;
    END get_hotel_ref;

-- #############################################################################

    PROCEDURE display_all_hotels IS
        CURSOR cur IS SELECT hotel_id, name, star_rating FROM HOTELS;
        v_id NUMBER;
        v_name VARCHAR2(100);
        v_stars NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Available hotels:');

        OPEN cur;

        LOOP
            FETCH cur INTO v_id, v_name, v_stars;
            EXIT WHEN cur%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('#'||v_id||' Name: '||v_name||' Stars: '||v_stars);
        END LOOP;

        CLOSE cur;

    END display_all_hotels;

-- #############################################################################

END UTILS;

/
--------------------------------------------------------
--  Constraints for Table EMPS_OT
--------------------------------------------------------

  ALTER TABLE "MATI"."EMPS_OT" ADD UNIQUE ("SYS_NC_OID$")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."EMPS_OT" ADD PRIMARY KEY ("EMP_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."EMPS_OT" MODIFY ("JOB" NOT NULL ENABLE);
  ALTER TABLE "MATI"."EMPS_OT" MODIFY ("SALARY" NOT NULL ENABLE);
  ALTER TABLE "MATI"."EMPS_OT" MODIFY ("HIRE_DATE" NOT NULL ENABLE);
  ALTER TABLE "MATI"."EMPS_OT" MODIFY ("LAST_NAME" NOT NULL ENABLE);
  ALTER TABLE "MATI"."EMPS_OT" MODIFY ("FIRST_NAME" NOT NULL ENABLE);
  ALTER TABLE "MATI"."EMPS_OT" MODIFY ("HOTEL_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table HOTELS
--------------------------------------------------------

  ALTER TABLE "MATI"."HOTELS" ADD UNIQUE ("SYS_NC_OID$")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."HOTELS" ADD UNIQUE ("ROOMS")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."HOTELS" ADD UNIQUE ("RESERVATIONS")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."HOTELS" ADD PRIMARY KEY ("HOTEL_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."HOTELS" MODIFY ("NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ADDRESS_OT
--------------------------------------------------------

  ALTER TABLE "MATI"."ADDRESS_OT" ADD UNIQUE ("SYS_NC_OID$")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."ADDRESS_OT" ADD PRIMARY KEY ("ADDRESS_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."ADDRESS_OT" MODIFY ("APARTMENT_NUMBER" NOT NULL ENABLE);
  ALTER TABLE "MATI"."ADDRESS_OT" MODIFY ("STREET" NOT NULL ENABLE);
  ALTER TABLE "MATI"."ADDRESS_OT" MODIFY ("CITY" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CUSTOMER_OT
--------------------------------------------------------

  ALTER TABLE "MATI"."CUSTOMER_OT" ADD UNIQUE ("SYS_NC_OID$")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."CUSTOMER_OT" ADD PRIMARY KEY ("CUSTOMER_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PROJEKT_HOTEL"  ENABLE;
  ALTER TABLE "MATI"."CUSTOMER_OT" MODIFY ("ADDRESS" NOT NULL ENABLE);
  ALTER TABLE "MATI"."CUSTOMER_OT" MODIFY ("PHONE_NUMBER" NOT NULL ENABLE);
  ALTER TABLE "MATI"."CUSTOMER_OT" MODIFY ("LAST_NAME" NOT NULL ENABLE);
  ALTER TABLE "MATI"."CUSTOMER_OT" MODIFY ("FIRST_NAME" NOT NULL ENABLE);
