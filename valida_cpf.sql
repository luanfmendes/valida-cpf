create or replace FUNCTION validar_cpf (p_cpf IN VARCHAR2) RETURN BOOLEAN IS
    v_cpf NUMBER(11);
    v_soma1 NUMBER := 0;
    v_soma2 NUMBER := 0;
    v_digito1 NUMBER(1);
    v_digito2 NUMBER(1);
BEGIN
    -- Remove os caracteres não numéricos
   v_cpf := TO_NUMBER(REGEXP_REPLACE(TRANSLATE(p_cpf, '-/', '  '), '[^[:digit:]]', ''));
 
    -- Verifica se o CPF tem 11 dígitos
    IF LENGTH(v_cpf) <> 11 THEN
        RETURN FALSE;
    END IF;

    -- Cálculo do primeiro dígito verificador
    FOR i IN 1..9 LOOP
        v_soma1 := v_soma1 + SUBSTR(v_cpf, i, 1) * (11 - i);
    END LOOP;
    v_digito1 := MOD(11 - MOD(v_soma1, 11), 10);

    -- Cálculo do segundo dígito verificador
    FOR i IN 1..10 LOOP
        v_soma2 := v_soma2 + SUBSTR(v_cpf, i, 1) * (12 - i);
    END LOOP;
    v_digito2 := MOD(11 - MOD(v_soma2, 11), 10);

    -- Verifica se os dígitos verificadores estão corretos
    IF SUBSTR(v_cpf, 10, 1) = v_digito1 AND SUBSTR(v_cpf, 11, 1) = v_digito2 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN OTHERS 
    THEN
     RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle - ' || SQLCODE || SQLERRM);
END;