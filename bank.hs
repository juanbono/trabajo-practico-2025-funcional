import GHC.IO (unsafePerformIO)

data TransactionType
  = Deposit Double String -- monto, cuenta_destino
  | Withdrawal Double String -- monto, cuenta_origen
  | Transfer Double String String -- monto, origen, destino
  deriving (Show, Eq)

type TimeStamp = Int

data Transaction
  = Transaction TransactionType TimeStamp String -- tipo, timestamp, descripción
  | InvalidTransaction String -- línea inválida
  deriving (Show, Eq)

-- Lee y devuelve las lines como strings
leerArchivo :: String -> [String]
leerArchivo archivo = lines $ unsafePerformIO (readFile archivo)
