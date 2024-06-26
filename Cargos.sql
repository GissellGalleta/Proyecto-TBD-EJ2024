-- SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$

-- Funciones, Triggers y Procedimientos para la tabla CARGOS

-- Función para verificar la existencia de un registro en CARGOS
DROP FUNCTION IF EXISTS Existe_CARGOS $$

CREATE FUNCTION Existe_CARGOS(CAR_FOLIO CHAR(10), ANT_DOCTO_CC_ID DOUBLE) RETURNS BOOLEAN
BEGIN
    DECLARE existe BOOLEAN;
    SELECT COUNT(CARGOS.CAR_IMPORTE) > 0 INTO existe
    FROM CARGOS
    WHERE CARGOS.CAR_FOLIO = CAR_FOLIO AND CARGOS.ANT_DOCTO_CC_ID = ANT_DOCTO_CC_ID;
    RETURN existe;
END $$


-- Trigger antes de insertar en CARGOS
DROP TRIGGER IF EXISTS Antes_Insertar_CARGOS $$

CREATE TRIGGER Antes_Insertar_CARGOS
BEFORE INSERT ON CARGOS
FOR EACH ROW
BEGIN
    IF Existe_CARGOS(NEW.CAR_FOLIO, NEW.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro ya existe en CARGOS';
    ELSEIF NOT Existe_LOTE(NEW.L_MANZANA, NEW.L_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO existe el Lote referenciado';
    ELSEIF NOT Existe_CLIENTES(NEW.CL_NUMERO) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO existe el Cliente referenciado';
    END IF;
END $$

-- Trigger antes de actualizar en CARGOS
DROP TRIGGER IF EXISTS Antes_Eliminar_CARGOS $$

DROP TRIGGER IF EXISTS Antes_Eliminar_CARGOS $$

CREATE TRIGGER Antes_Eliminar_CARGOS
BEFORE DELETE ON CARGOS
FOR EACH ROW
BEGIN
    IF NOT Existe_CARGOS(OLD.CAR_FOLIO, OLD.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en CARGOS';
    END IF;
END $$


-- Trigger antes de eliminar en CARGOS

DROP TRIGGER IF EXISTS Antes_Eliminar_CARGOS $$

CREATE TRIGGER Antes_Eliminar_CARGOS
BEFORE DELETE ON CARGOS
FOR EACH ROW
BEGIN
    IF NOT Existe_CARGOS(OLD.CAR_FOLIO, OLD.ANT_DOCTO_CC_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en CARGOS';
    END IF;
END $$


-- Procedimiento almacenado para insertar en CARGOS
DROP PROCEDURE IF EXISTS Insertar_CARGOS $$

CREATE PROCEDURE Insertar_CARGOS(
    IN p_CAR_FOLIO CHAR(10),
    IN p_ANT_DOCTO_CC_ID DOUBLE,
    IN p_L_MANZANA CHAR(3),
    IN p_L_NUMERO CHAR(6),
    IN p_CON_CLAVE SMALLINT,
    IN p_CAR_FECHA DATETIME,
    IN p_CAR_IMPORTE DOUBLE,
    IN p_CAR_IVA DOUBLE,
    IN p_CAR_DESCRIPCION CHAR(100),
    IN p_CL_NUMERO DOUBLE,
    IN p_CAR_POLIZA_PRO CHAR(8),
    IN p_ANT_CLIENTE_ID INT,
    IN p_ANT_CONC_CC_ID INT,
    IN p_CAR_FECHA_VENCE DATETIME,
    IN p_CAR_DESCUENTO DOUBLE,
    IN p_CAR_INICIO SMALLINT
)
BEGIN
    -- Intentar la inserción
    INSERT INTO CARGOS (
        CAR_FOLIO, ANT_DOCTO_CC_ID, L_MANZANA, L_NUMERO, CON_CLAVE, CAR_FECHA,
        CAR_IMPORTE, CAR_IVA, CAR_DESCRIPCION, CL_NUMERO, CAR_POLIZA_PRO,
        ANT_CLIENTE_ID, ANT_CONC_CC_ID, CAR_FECHA_VENCE, CAR_DESCUENTO, CAR_INICIO
    ) VALUES (
        p_CAR_FOLIO, p_ANT_DOCTO_CC_ID, p_L_MANZANA, p_L_NUMERO, p_CON_CLAVE, p_CAR_FECHA,
        p_CAR_IMPORTE, p_CAR_IVA, p_CAR_DESCRIPCION, p_CL_NUMERO, p_CAR_POLIZA_PRO,
        p_ANT_CLIENTE_ID, p_ANT_CONC_CC_ID, p_CAR_FECHA_VENCE, p_CAR_DESCUENTO, p_CAR_INICIO
    );
END $$


-- Procedimiento almacenado para eliminar en CARGOS
DROP PROCEDURE IF EXISTS Eliminar_CARGOS $$

CREATE PROCEDURE Eliminar_CARGOS(
    IN p_CAR_FOLIO CHAR(10),
    IN p_ANT_DOCTO_CC_ID DOUBLE
)
BEGIN
    -- Validar tipo de dato de la llave primaria
    DELETE FROM CARGOS WHERE CAR_FOLIO = p_CAR_FOLIO AND ANT_DOCTO_CC_ID = p_ANT_DOCTO_CC_ID;
END $$

-- Procedimiento almacenado para buscar en CARGOS
DROP PROCEDURE IF EXISTS Buscar_CARGOS $$

CREATE PROCEDURE Buscar_CARGOS(
    IN p_CAR_FOLIO CHAR(10),
    IN p_ANT_DOCTO_CC_ID DOUBLE
)
BEGIN
    -- Validar tipos de datos
    IF p_CAR_FOLIO IS NULL OR p_ANT_DOCTO_CC_ID IS NULL THEN
        SELECT * FROM CARGOS;
    ELSE
        IF Existe_CARGOS(p_CAR_FOLIO, p_ANT_DOCTO_CC_ID) THEN
            SELECT * FROM CARGOS WHERE CAR_FOLIO = p_CAR_FOLIO AND ANT_DOCTO_CC_ID = p_ANT_DOCTO_CC_ID;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El registro no existe en CARGOS';
        END IF;
    END IF;
END $$

-- Procedimiento almacenado para actualizar en CARGOS
DROP PROCEDURE IF EXISTS Actualizar_CARGOS $$

    CREATE PROCEDURE Actualizar_CARGOS(
        IN p_CAR_FOLIO CHAR(10),
        IN p_ANT_DOCTO_CC_ID DOUBLE,
        IN p_L_MANZANA CHAR(3),
        IN p_L_NUMERO CHAR(6),
        IN p_CON_CLAVE SMALLINT(6),
        IN p_CAR_FECHA DATETIME,
        IN p_CAR_IMPORTE DOUBLE,
        IN p_CAR_IVA DOUBLE,
        IN p_CAR_DESCRIPCION CHAR(100),
        IN p_CL_NUMERO DOUBLE,
        IN p_CAR_POLIZA_PRO CHAR(8),
        IN p_ANT_CLIENTE_ID INT(11),
        IN p_ANT_CONC_CC_ID INT(11),
        IN p_CAR_FECHA_VENCE DATETIME,
        IN p_CAR_DESCUENTO DOUBLE,
        IN p_CAR_INICIO SMALLINT(6)
    )
    BEGIN
        -- Validación de tipos y restricciones aquí

        -- Intentar la actualización
        UPDATE CARGOS
        SET
            L_MANZANA = p_L_MANZANA,
            L_NUMERO = p_L_NUMERO,
            CON_CLAVE = p_CON_CLAVE,
            CAR_FECHA = p_CAR_FECHA,
            CAR_IMPORTE = p_CAR_IMPORTE,
            CAR_IVA = p_CAR_IVA,
            CAR_DESCRIPCION = p_CAR_DESCRIPCION,
            CL_NUMERO = p_CL_NUMERO,
            CAR_POLIZA_PRO = p_CAR_POLIZA_PRO,
            ANT_CLIENTE_ID = p_ANT_CLIENTE_ID,
            ANT_CONC_CC_ID = p_ANT_CONC_CC_ID,
            CAR_FECHA_VENCE = p_CAR_FECHA_VENCE,
            CAR_DESCUENTO = p_CAR_DESCUENTO,
            CAR_INICIO = p_CAR_INICIO
        WHERE CAR_FOLIO = p_CAR_FOLIO AND ANT_DOCTO_CC_ID = p_ANT_DOCTO_CC_ID;
    END $$

DELIMITER ;