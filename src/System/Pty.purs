module System.Pty where

import Prelude
import Data.StrMap (StrMap)
import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Uncurried (EffFn1, EffFn2, EffFn3)



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

foreign import writeImpl :: forall eff. EffFn2 (pty :: PTY | eff) PtyProcess String Unit

foreign import onDataImpl :: forall eff. EffFn2 (pty :: PTY | eff) PtyProcess (EffFn1 (pty :: PTY | eff) String Unit) Unit

foreign import resizeImpl :: forall eff. EffFn2 (pty :: PTY | eff) PtyProcess {cols :: Int, rows :: Int} Unit
