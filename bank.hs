import GHC.IO (unsafePerformIO)

-- | Representa los tipos de transacciones posibles
data TransactionType
  -- | Deposit: deposito de un monto dado (como Double) a una cuenta.
  = Deposit Double String 
  -- | Withdrawal: retiro de un monto dado (como Double) de una cuenta.
  | Withdrawal Double String 
  -- | Transfer: transferencia de un monto dado (como Double) de una cuenta origen a una cuenta destino.
  | Transfer { monto :: Double, origen:: String, destino :: String }
  deriving (Show, Eq) 

-- | Tipo de dato de las transacciones. Puede o bien ser una transaccion correcta o una transaccion inválida.
data Transaction
  -- | Transaction: transacción con un tipo, timestamp y descripción.
  = Transaction { tipo :: TransactionType, timestamp :: Int, descripcion :: String}
  -- | InvalidTransaction: transacción inválida, contiene el string original.
  | InvalidTransaction String 
  deriving (Show, Eq)

-- | Lee un archivo y devuelve la lista de lineas del archivo.
-- El String que recibe como parametro debe ser la ruta al archivo de transacciones.
readTransactionFile :: String -> [String]
readTransactionFile archivo = lines $ unsafePerformIO (readFile archivo)
