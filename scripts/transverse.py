import os
import sys

def info(fullpath):
    try:
        size = os.path.getsize(fullpath)
    except OSError:
        size = -1
    return "#".join([str(os.path.isdir(fullpath)), str(os.path.isfile(fullpath)),
                    str(os.path.islink(fullpath)), fullpath,
                    os.path.realpath(fullpath), str(size)])

if __name__ == "__main__":
    """
        It transverses the file system collecting file types and sizes.
        python $0 rootname > out
    """
    for dirpath, dirnames, filenames in os.walk(sys.argv[1]):
        for fname in filenames:
            print info(os.path.join(dirpath, fname))
        for dname in dirnames:
            print info(os.path.join(dirpath, dname))
