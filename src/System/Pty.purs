module System.Pty
  ( PtyProcess, PTY, PtySpawnArgs, PtySpawnParams, spawn, write, onData, resize, destroy
  ) where

import Prelude
import Data.StrMap (StrMap)
import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Uncurried (EffFn1, EffFn2, EffFn3, mkEffFn1, runEffFn1, runEffFn2, runEffFn3)



foreign import data PtyProcess :: Type

foreign import data PTY :: Effect

data PtySpawnArgs

type PtySpawnParams =
  { name :: String
  , cols :: Int
  , rows :: Int
  , cwd :: String
  , env :: StrMap String
  }

foreign import spawnImpl :: forall eff. EffFn3 (pty :: PTY | eff) String (Array PtySpawnArgs) PtySpawnParams PtyProcess

spawn :: forall eff. String -> Array PtySpawnArgs -> PtySpawnParams -> Eff (pty :: PTY | eff) PtyProcess
spawn = runEffFn3 spawnImpl

foreign import writeImpl :: forall eff. EffFn2 (pty :: PTY | eff) PtyProcess String Unit

write :: forall eff. PtyProcess -> String -> Eff (pty :: PTY | eff) Unit
write = runEffFn2 writeImpl

foreign import onDataImpl :: forall eff. EffFn2 (pty :: PTY | eff) PtyProcess (EffFn1 (pty :: PTY | eff) String Unit) Unit

onData :: forall eff. PtyProcess -> (String -> Eff (pty :: PTY | eff) Unit) -> Eff (pty :: PTY | eff) Unit
onData p f = runEffFn2 onDataImpl p (mkEffFn1 f)

foreign import resizeImpl :: forall eff. EffFn2 (pty :: PTY | eff) PtyProcess {cols :: Int, rows :: Int} Unit

resize :: forall eff. PtyProcess -> {cols :: Int, rows :: Int} -> Eff (pty :: PTY | eff) Unit
resize = runEffFn2 resizeImpl

foreign import destroyImpl :: forall eff. EffFn1 (pty :: PTY | eff) PtyProcess Unit

destroy :: forall eff. PtyProcess -> Eff (pty :: PTY | eff) Unit
destroy = runEffFn1 destroyImpl
