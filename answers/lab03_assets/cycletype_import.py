
import os
import sys
import warnings

from ctypes import CDLL

platform_name = sys.platform


try:
    # linux or macos
    if platform_name == 'Linux' or platform_name == 'Darwin':
        ext = '.so'
        winmode = None
    elif platform_name == 'Win2':
        if sys.version_info.minor < 8:
            raise NotImplementedError(f'Python version should be >=3.8')

        ext = '.dll'
        winmode = 0     # for windows to find DLL file
    else:
        raise NotImplementedError(f'Not supported platform {platform_name}')

    # fixme: definitely shouldn't be like that
    dir_path = os.path.dirname(os.path.realpath(__file__))
    aux_path = os.path.join(dir_path, 'build')
    lib_path = os.path.join(dir_path, 'build', f'simulation{ext}')
    src_path = os.path.join(dir_path, 'simulation.cpp')
    tmp_path = os.path.join(dir_path, 'build', 'simulation.o')

    # todo: compilation should be on the setup step, instead of importing
    if not os.path.exists(lib_path):
        if not os.path.exists(aux_path):
            os.makedirs(aux_path)
        warnings.warn(f"Didn't find {ext} file, trying to make one...")
        os.system(f'g++ -c -fPIC {src_path} -o {tmp_path} && g++ -shared -Wl,-soname,{lib_path} -o {lib_path}  {tmp_path}')

    _module = CDLL(lib_path, winmode=winmode)

# if we can't compile or miss some file, raise ImportError for the training_pipeline.py, and
# use Python variant instead
except Exception as e:
    warnings.warn(f'Exception during C/CPP source compilation: {e}')
    raise ImportError
