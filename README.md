## Análisis de Transacciones Bancarias

## Situación Problemática

¡El sistema bancario ha sufrido un ataque cibernético! Los hackers han mezclado y corrompido los archivos con las transacciones bancarias. Necesitamos un programa para analizar estas transacciones, calcular balances de cuentas e identificar actividades sospechosas.
Para ayudarnos a resolver este problema, el banco nos proporciono parte del archivo de transacciones. 

---

## Formato del archivo de Transacciones

Cada línea del archivo representa una transacción diferente. Cada línea comienza con un carácter que indica el tipo de transacción:

- **'D'** para depósitos (Deposits)
- **'W'** para retiros (Withdrawals)  
- **'T'** para transferencias (Transfers)

### Formato específico por tipo:

**Depósitos:** `D <timestamp> <monto> <cuenta_destino> <descripcion>`
- Ejemplo: `D 1640995200 1500.50 ACC001 Salary deposit`

**Retiros:** `W <timestamp> <monto> <cuenta_origen> <descripcion>`
- Ejemplo: `W 1640995800 200.00 ACC001 ATM withdrawal`

**Transferencias:** `T <timestamp> <monto> <cuenta_origen> <cuenta_destino> <descripcion>`
- Ejemplo: `T 1641000000 750.25 ACC001 ACC002 Rent payment`

Los timestamps son numeros enteros que representan formato [Unix Timestamp](https://es.wikipedia.org/wiki/Tiempo_Unix), y los montos son numeros en coma flotante de doble precision.

---

## Tipos de Datos Proporcionados

```haskell
-- | Representa los tipos de transacciones posibles
data TransactionType
  -- | Deposit: deposito de un monto dado (como Double) a una cuenta.
  = Deposit Double String
  -- | Withdrawal: retiro de un monto dado (como Double) de una cuenta.
  | Withdrawal Double String 
  -- | Transfer: transferencia de un monto dado (como Double) de una cuenta origen a una cuenta destino.
  | Transfer Double String String 
  deriving (Show, Eq) 

-- | Tipo de dato de las transacciones. Puede o bien ser una transaccion correcta o una transaccion inválida.
data Transaction
  -- | Transaction: transacción con un tipo, timestamp y descripción.
  = Transaction { tipo :: TransactionType, timestamp :: Int, descripcion :: String}
  -- | InvalidTransaction: transacción inválida, contiene el string original.
  | InvalidTransaction String 
  deriving (Show, Eq)
```

---

## Ejercicios

### Ejercicio 1: Parseo de Transacciones 

Antes de comenzar el analisis de los logs, deberemos convertir cada elemento del archivo en un tipo de dato que represente cada transaccion.

Para ello deberemos procesar cada linea del archivo (un string) y convertirla en un tipo de dato `Transaction` e implementar la siguiente funcion:
```haskell
parseTransaction :: String -> Transaction
```

Esta función debe parsear una línea individual del archivo de transacciones.

**Ejemplos:**
```haskell
parseTransaction "D 1640995200 1500.50 ACC001 Salary deposit"
== Transaction (Deposit 1500.50 "ACC001") 1640995200 "Salary deposit"

parseTransaction "W 1640995800 200.00 ACC002 ATM withdrawal"  
== Transaction (Withdrawal 200.00 "ACC002") 1640995800 "ATM withdrawal"

parseTransaction "T 1641000000 750.25 ACC001 ACC002 Rent payment"
== Transaction (Transfer 750.25 "ACC001" "ACC002") 1641000000 "Rent payment"

parseTransaction "Invalid line format"
== InvalidTransaction "Invalid line format"
```

Una vez completada esta primer tarea, vamos a estar en condiciones de parsear el archivo de transacciones completo.
Para eso, implementa la funcion `parseTransactions` con el siguiente tipo:
```haskell
parseTransactions :: String -> [Transaction]
```
Esta funcion debera tomar como argumento el path del archivo (su ruta en el sistema de archivos), procesar cada linea del archivo y devolver una lista de transacciones.

Por suerte, el equipo interno del banco nos proporciono la funcion `readTransactionFile` que nos permite leer el archivo de transacciones y obtener una lista de strings, donde cada uno representa una linea del archivo. Se aconseja probar esta funcion en el interprete para ver como funciona.

**Ejemplo:**
```haskell
parseTransactions "transactions.log"
== [Transaction (Deposit 1500.50 "ACC001") 1640995200 "Salary deposit",
    Transaction (Withdrawal 200.00 "ACC002") 1640995800 "ATM withdrawal",
    Transaction (Transfer 750.25 "ACC001" "ACC002") 1641000000 "Rent payment",
    InvalidTransaction "Invalid line format"]
```

---

### Ejercicio 2: Cálculo de Balance de Cuenta

Ahora que tenemos las transacciones parseadas, estamos en condiciones de comenzar el analisis.

Para ello deberemos implementar la función:
```haskell
accountBalance :: String -> [Transaction] -> Double
```

Esta función debera calcular el balance final de una cuenta específica considerando todas las transacciones que la afectan:
- **Depósitos:** suman al balance de la cuenta destino
- **Retiros:** restan del balance de la cuenta origen  
- **Transferencias:** restan del balance de la cuenta origen y suman al balance de la cuenta destino

**Ejemplo:**
```haskell
-- Si tenemos estas transacciones:
-- D 100 500.0 ACC001 "Initial deposit"
-- W 200 100.0 ACC001 "Withdrawal" 
-- T 300 50.0 ACC001 ACC002 "Transfer to ACC002"

accountBalance "ACC001" transactions == 350.0  -- 500 - 100 - 50
accountBalance "ACC002" transactions == 50.0   -- +50 de la transferencia
```

**Nota:** Asume que todas las cuentas comienzan con balance 0.

---

### Ejercicio 3: Identificación de Transacciones Sospechosas 

Implementa la función:
```haskell
suspiciousTransactions :: [Transaction] -> [String]
```

Esta función debe:
1. Filtrar transacciones "sospechosas" según estos criterios:
   - Retiros mayores a $5000
   - Transferencias mayores a $10000
   - Depósitos mayores a $15000
2. Ordenar las transacciones sospechosas por timestamp (de menor a mayor)
3. Devolver solo las descripciones de estas transacciones

---

### Ejercicio 4: Resumen de Actividad por Cuenta

Implementa la función:
```haskell
accountSummary :: String -> [Transaction] -> AccountSummary
```

Esta función debe devolver un resumen de la actividad de una cuenta específica en formato:

```haskell
data AccountSummary = AccountSummary
  { depositsCount    :: Int -- número de depósitos recibidos
  , withdrawalsCount :: Int --número de retiros realizados  
  , transfersCount   :: Int -- número de transferencias (enviadas + recibidas)
  , finalBalance     :: Double -- balance final de la cuenta
   } deriving (Show, Eq)

```


**Ejemplo:**
```haskell
accountSummary "ACC001" transactions ==
  AccountSummary
    { depositsCount    = 2
    , withdrawalsCount = 1
    , transfersCount   = 3
    , finalBalance     = 850.25
    }
-- 2 depósitos recibidos, 1 retiro realizado,
-- 3 transferencias (enviadas/recibidas),
-- balance final 850.25
```


## Datos de Prueba

### Contenido de `transactions.log`:
```
D 1640995200 1500.50 ACC001 Salary deposit
W 1640995800 200.00 ACC001 ATM withdrawal
T 1641000000 750.25 ACC001 ACC002 Rent payment
D 1640999000 25000.00 ACC003 Suspicious large deposit
W 1641005000 7500.00 ACC002 Large withdrawal
T 1641010000 12000.00 ACC003 ACC004 Large transfer
D 1641015000 500.00 ACC001 Normal deposit
Invalid transaction line
W 1641020000 100.00 ACC004 Small withdrawal
T 1641025000 15000.00 ACC004 ACC001 Another large transfer
```

### Resultados esperados:

**Balance de ACC001:**
- +1500.50 (depósito inicial)
- -200.00 (retiro)  
- -750.25 (transferencia enviada)
- +500.00 (segundo depósito)
- +15000.00 (transferencia recibida)
- **Total: 16050.25**

**Transacciones sospechosas:**
```
[ "Suspicious large deposit"     -- D 25000 > 15000
, "Large withdrawal"             -- W 7500 > 5000  
, "Large transfer"               -- T 12000 > 10000
, "Another large transfer"       -- T 15000 > 10000
]
```


---

## Consideraciones Importantes

- **No hardcodees valores específicos** - tu solución será probada con otros archivos de transacciones
- **Las transacciones inválidas deben ser ignoradas** en todos los cálculos y análisis
- **Maneja casos borde** como cuentas inexistentes (deben devolver balance 0)



