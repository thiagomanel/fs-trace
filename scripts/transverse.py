import os
import sys
import stat

def info(fullpath):

    try:
        _stat = os.stat(fullpath)
    except OSError:
        _stat = os.lstat(fullpath)

    mode = _stat.st_mode
    size = _stat.st_size

    return "#".join([str(stat.S_ISDIR(mode)), str(stat.S_ISCHR(mode)),\
                     str(stat.S_ISBLK(mode)), str(stat.S_ISREG(mode)),\
                     str(stat.S_ISFIFO(mode)), str(stat.S_ISSOCK(mode)),\
                     str(stat.S_ISLNK(mode)),\
                     fullpath, os.path.realpath(fullpath),\
                     str(size)])

if __name__ == "__main__":
    """
        It transverses the file system collecting file types and sizes.
        python $0 rootname > out
    """
    for dirpath, dirnames, filenames in os.walk(sys.argv[1], followlinks=True):
        for fname in filenames:
            print info(os.path.join(dirpath, fname))
        for dname in dirnames:
            print info(os.path.join(dirpath, dname))
