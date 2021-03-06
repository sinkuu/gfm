module gfm.bgfx.bgfx;

import derelict.bgfx.bgfx;
import derelict.util.exception;

/// General bgfx exception thrown for all cases.
/// However, bgfx has no recoverable errors.
final class BgfxException : Exception
{
    public
    {
        @safe pure nothrow this(string message, string file =__FILE__, size_t line = __LINE__, Throwable next = null)
        {
            super(message, file, line, next);
        }
    }
}

/// Owns the loader.
/// This object is passed around to other wrapped objects
/// to ensure library loading.
final class Bgfx
{
    public
    {
        /// Loads DerelictENet and initializes the ENet library.
        /// Throws: ENetException when enet_initialize fails.
        this()
        {   
            try
                DerelictBgfx.load();
            catch(DerelictException e)
                throw new BgfxException(e.msg);
     
            bgfx_init(); // TODO pass interfaces

            _bgfxInitialized = true;



    scope(exit) bgfx_shutdown();

    bgfx_reset(width, height, reset);
        }
    
        ~this()
        {
            close();
        }

        /// Deinitializes the ENet library and unloads DerelictENet.
        void close()
        {
            if(_bgfxInitialized)
            {
                bgfx_shutdown();
                DerelictBgfx.unload();
                _bgfxInitialized = false;
            }
        }
    }

    private
    {
        bool _bgfxInitialized = false;

    }
}
