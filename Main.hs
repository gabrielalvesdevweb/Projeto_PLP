import System.Exit
import Data.Time.Clock
import System.IO

main :: IO()
main = do
  menu
    
menu :: IO()
menu = do
  putStrLn("Menu:\n\n" ++ "1. Registrar\n" ++ "2. Login\n"++ "3. Ajuda\n"++ "4. Sair\n")
  dados <- getLine
  let opcao = read(dados)
  if opcao == 1 then do
    putStrLn "Digite o nome de usuário:"
    userName <- getLine
    registraUser userName
  else if opcao == 2 then login
  else if opcao == 3 then do
    guia <- readFile "guia.txt"
    putStrLn guia
    putStrLn "Pressione enter para retornar ao menu..."
    descarte <- getLine
    menu
  else if opcao == 4 then exitSuccess
  else menu

login :: IO()
login = do
  users <- readFile "listaUsuarios.txt"
  let usuarios = separaPalavras (== ' ') users
  putStrLn "Digite o seu nome de usuário para restaurar seu progresso"
  userName <- getLine
  if(userName `elem` usuarios) then do
    putStrLn "\n Usuário localizado no sistema!"
    nivel <- readFile ("Usuarios/"++userName++".txt")
    ajusteNivel userName nivel
  else do
    putStrLn "Esse usuário não está registrado no sistema!\n"
    menu

ajusteNivel :: String -> String -> IO()
ajusteNivel userName nivel = do
  let msg = "Seu nível atual é "++ nivel++" \n"
  putStrLn msg
  putStrLn "Deseja continuar do nível onde parou ou começar o desafio novamente?\n 1. Continuar \n 2. Reiniciar"
  opcao <- getLine
  let escolha = read(opcao)
  if (escolha == 1) then recuperarProgresso nivel userName
  else if (escolha == 2) then facil 1 userName
  else ajusteNivel userName nivel


recuperarProgresso :: String -> String -> IO()
recuperarProgresso nivel nome = do
  if(nivel == "facil") then facil 1 nome
  else if (nivel == "medio") then medio 1 nome
  else dificil 1 nome

registraUser :: String -> IO()
registraUser userName  = do
  writeFile ("Usuarios/"++userName++".txt") $ "facil"
  appendFile "listaUsuarios.txt" (userName++" ")
  facil 1 userName

controlaNivelFacil :: Int -> IO String
controlaNivelFacil nvl =
  if nvl == 1 then readFile "facil1.txt"
  else if nvl == 2 then readFile "facil2.txt"
  else readFile "facil3.txt"

controlaNivelMedio :: Int -> IO String
controlaNivelMedio nvl =
  if nvl == 1 then readFile "medio1.txt"
  else if nvl == 2 then readFile "medio2.txt"
  else readFile "medio3.txt"

controlaNivelDificil :: Int -> IO String
controlaNivelDificil nvl =
  if nvl == 1 then readFile "dificil1.txt"
  else if nvl == 2 then readFile "dificil2.txt"
  else readFile "dificil3.txt"

facil :: Int -> String -> IO()
facil 4 nome = do
  writeFile ("Usuarios/"++nome++".txt") "medio"
  medio 1 nome
facil nivel nome = do
  putStrLn "Dificuldade: Fácil"
  let nivelStr = "Nível: " ++ show nivel ++ "\n"
  putStrLn nivelStr
  dados <- controlaNivelFacil (nivel) 
  let texto = separaPalavras (== ' ') dados
  parada
  putStrLn dados
  t1 <- getCurrentTime
  x <- getLine
  t2 <- getCurrentTime
  let myNominalDiffTime = diffUTCTime t2 t1
  let (myNominalDiffTimeInSeconds, _) = properFraction myNominalDiffTime
  let textoArray = separaPalavras (== ' ') x
  let verificacao = ehigual texto textoArray 0
  if (myNominalDiffTimeInSeconds > 60) then do
    putStrLn "\n O tempo máximo para digitação foi superado. Tente novamente!"
    facil nivel nome
  else if(verificacao==0 && 60 >= myNominalDiffTimeInSeconds ) then do
    putStrLn "Parabéns, você passou para o próximo nível!\n"
    let msg = ("Tempo gasto para digitar o texto proposto: "++ show myNominalDiffTimeInSeconds ++" segundos.")
    putStrLn msg
    let ppm2 = ppm(length texto) myNominalDiffTimeInSeconds
    let msg2 = ("Palavras por minuto (PPM): "++ show ppm2)
    putStrLn msg2
    facil (nivel + 1) nome
  else if(verificacao== -1) then do
    putStrLn "O texto digitado é maior que o texto fornecido!\n"
    facil nivel nome
  else if(verificacao== -2) then do
    putStrLn "O texto fornecido é maior que o texto digitado!\n"  
    facil nivel nome
  else do 
    let msgErro = ("Erro ao Digitar. Voce digitou "++ show verificacao ++" Palavras erradas.  Tente novamente!\n")
    putStrLn msgErro
    facil nivel nome

medio :: Int -> String -> IO()
medio 4 nome = do
  writeFile ("Usuarios/"++nome++".txt") "dificil"
  dificil 1 nome
medio nivel nome = do
  putStrLn "Dificuldade: Média"
  let nivelStr = "Nível: " ++ show nivel ++"\n"
  putStrLn nivelStr
  dados <- controlaNivelMedio (nivel) 
  let texto = separaPalavras (== ' ') dados
  parada
  putStrLn dados
  t1 <- getCurrentTime
  x <- getLine
  t2 <- getCurrentTime
  let myNominalDiffTime = diffUTCTime t2 t1
  let (myNominalDiffTimeInSeconds, _) = properFraction myNominalDiffTime
  let textoArray = separaPalavras (== ' ') x
  let verificacao = ehigual texto textoArray 0
  if (myNominalDiffTimeInSeconds > 60) then do
    putStrLn "\n O tempo máximo para digitação foi superado. Tente novamente!"
    medio nivel nome
  else if(verificacao==0 && 60 >= myNominalDiffTimeInSeconds ) then do
    putStrLn "Parabéns, você passou para o próximo nível!\n"
    let msg = ("Tempo gasto para digitar o texto proposto: "++ show myNominalDiffTimeInSeconds ++" segundos.")
    putStrLn msg
    let ppm2 = ppm(length texto) myNominalDiffTimeInSeconds
    let msg2 = ("Palavras por minuto (PPM): "++ show ppm2)
    putStrLn msg2
    medio (nivel+1) nome
  else if(verificacao== -1) then do
    putStrLn "O texto digitado é maior que o texto fornecido!\n"
    medio nivel nome
  else if(verificacao== -2) then do
    putStrLn "O texto fornecido é maior que o texto digitado!\n"  
    medio nivel nome
  else do
    let msgErro = ("Erro ao Digitar. Voce digitou "++ show verificacao ++" Palavras erradas.  Tente novamente!\n")
    putStrLn msgErro
    medio nivel nome

dificil :: Int -> String -> IO()
dificil 4 nome = testeNovamente nome
dificil nivel nome = do
  putStrLn "Dificuldade: Difícil"
  let nivelStr = "Nível: " ++ show nivel ++"\n"
  putStrLn nivelStr
  dados <- controlaNivelDificil (nivel) 
  let texto = separaPalavras (== ' ') dados
  parada
  putStrLn dados
  t1 <- getCurrentTime
  x <- getLine
  t2 <- getCurrentTime
  let myNominalDiffTime = diffUTCTime t2 t1
  let (myNominalDiffTimeInSeconds, _) = properFraction myNominalDiffTime
  let textoArray = separaPalavras (== ' ') x
  let verificacao = ehigual texto textoArray 0
  if (myNominalDiffTimeInSeconds > 60) then do
    putStrLn "\n O tempo máximo para digitação foi superado. Tente novamente!"
    dificil nivel nome
  else if(verificacao==0 && 60 >= myNominalDiffTimeInSeconds) then do
    putStrLn "Parabéns, você concluiu com êxito o teste de datilografia!\n"
    let msg = ("Tempo gasto para digitar o texto proposto: "++ show myNominalDiffTimeInSeconds ++" segundos.")
    putStrLn msg
    let ppm2 = ppm(length texto) myNominalDiffTimeInSeconds
    let msg2 = ("Palavras por minuto (PPM): "++ show ppm2)
    putStrLn msg2
    dificil (nivel+1) nome
  else if(verificacao== -1) then do
    putStrLn "O texto digitado é maior que o texto fornecido!\n"
    dificil nivel nome
  else if(verificacao== -2) then do
    putStrLn "O texto fornecido é maior que o texto digitado!\n"  
    dificil nivel nome
  else do
    let msgErro = ("Erro ao Digitar. Voce digitou "++ show verificacao ++" Palavras erradas.  Tente novamente!\n")
    putStrLn msgErro
    dificil nivel nome

testeNovamente :: String -> IO()
testeNovamente nome = do
  putStrLn "Quer realizar o teste novamente no nível difícil?\n\n[S]im\n[N]ão\n"
  resposta <- getLine
  if(resposta == "S") then dificil 1 nome
  else if(resposta == "N") then menu
  else testeNovamente nome


separaPalavras :: (Char -> Bool) -> String -> [String]
separaPalavras p s = case dropWhile p s of
  "" -> []
  s' -> w : separaPalavras p s''
    where
      (w, s'') = break p s'

ehigual :: [String] -> [String] -> Int -> Int
ehigual [] [] 0 = 0
ehigual [] _ _ = -1
ehigual _ [] _ = -2
ehigual (a : as) (b : bs) contador
  | a == b = ehigual as bs contador
  | (a/=b) && (tail a /= []) = ehigual as bs contador+1
  | (a/=b) && (tail a == []) = contador+1

parada :: IO()
parada =  do
  putStrLn "Pressione enter quando estiver preparado ou digite 0 para voltar ao menu"
  descarte <- getLine
  if(descarte == "0") then menu
  else putStrLn "Começe a digitar! \n"

ppm :: Int -> Int -> Float
ppm x y = a / (b/60)
  where a = fromIntegral x :: Float
        b = fromIntegral y :: Float