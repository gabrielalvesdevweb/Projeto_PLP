{-# LINE 1 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}
module Data.Time.Clock.Internal.CTimespec where




{-# LINE 6 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}


{-# LINE 8 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}
import Foreign

{-# LINE 12 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}
import Foreign.C
import System.IO.Unsafe



type ClockID = Int32
{-# LINE 18 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}

data CTimespec = MkCTimespec CTime CLong

instance Storable CTimespec where
    sizeOf _ = (16)
{-# LINE 23 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}
    alignment _ = alignment (undefined :: CLong)
    peek p = do
        s  <- (\hsc_ptr -> peekByteOff hsc_ptr 0) p
{-# LINE 26 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}
        ns <- (\hsc_ptr -> peekByteOff hsc_ptr 8) p
{-# LINE 27 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}
        return (MkCTimespec s ns)
    poke p (MkCTimespec s ns) = do
        (\hsc_ptr -> pokeByteOff hsc_ptr 0) p s
{-# LINE 30 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}
        (\hsc_ptr -> pokeByteOff hsc_ptr 8) p ns
{-# LINE 31 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}

foreign import ccall unsafe "time.h clock_gettime"
    clock_gettime :: ClockID -> Ptr CTimespec -> IO CInt
foreign import ccall unsafe "time.h clock_getres"
    clock_getres :: ClockID -> Ptr CTimespec -> IO CInt

-- | Get the resolution of the given clock.
clockGetRes :: Int32 -> IO (Either Errno CTimespec)
{-# LINE 39 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}
clockGetRes clockid = alloca $ \ptspec -> do
    rc <- clock_getres clockid ptspec
    case rc of
        0 -> do
            res <- peek ptspec
            return $ Right res
        _ -> do
            errno <- getErrno
            return $ Left errno

-- | Get the current time from the given clock.
clockGetTime :: ClockID -> IO CTimespec
clockGetTime clockid = alloca (\ptspec -> do
    throwErrnoIfMinus1_ "clock_gettime" $ clock_gettime clockid ptspec
    peek ptspec
    )

clock_REALTIME :: ClockID
clock_REALTIME = 0
{-# LINE 58 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}

clock_TAI :: ClockID
clock_TAI = 11
{-# LINE 61 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}

realtimeRes :: CTimespec
realtimeRes = unsafePerformIO $ do
    mres <- clockGetRes clock_REALTIME
    case mres of
        Left errno -> ioError (errnoToIOError "clock_getres" errno Nothing Nothing)
        Right res -> return res

clockResolution :: ClockID -> Maybe CTimespec
clockResolution clockid = unsafePerformIO $ do
    mres <- clockGetRes clockid
    case mres of
        Left _ -> return Nothing
        Right res -> return $ Just res


{-# LINE 77 "lib/Data/Time/Clock/Internal/CTimespec.hsc" #-}
