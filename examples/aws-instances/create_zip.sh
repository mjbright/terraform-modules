
GROUPE="TEST"

die() { echo "$0: die - $*" >&2; exit 1; }

cd files/

CREATE_ZIP() {
    OP_ZIP=$1; shift
    FOLDER=$1; shift

    OP_ZIPS+=" $OP_ZIP"
    [ -f ${OP_ZIP} ] && { set -x; rm -f ${OP_ZIP}; set +x; }

    cd $FOLDER
        zip -r -9 ${OP_ZIP} ./ || die "Zip produced error code"
        unzip -l  ${OP_ZIP}
        ls   -al  ${OP_ZIP}
    cd -
}

MERGE_FOLDERS() {
    TMP_FOLDER=$1; shift

    [ "${TMP_FOLDER##*TMP}" = "${TMP_FOLDER}" ] &&
        [ -d $TMP_FOLDER ] &&
            die "Are you sure you want to delete non-TMP folder [$TMP_FOLDER]?"

    for FOLDER in $*; do
        #cp -a $FOLDER/ $TMP_FOLDER/
        [ ! -d "$FOLDER" ] && die "No such source folder '$FOLDER'"
        rsync -av $FOLDER/ $TMP_FOLDER/ || die "Rsync produced error code"
    done
}

OP_ZIPS=""

case $GROUP in
    TEST)
        TARGET_F="TMP-TEST"
        SRC_DIRS="TEST"
        OP_ZIP="$PWD/files.zip"
        MERGE_FOLDERS $TARGET_F $SRC_DIRS; CREATE_ZIP $OP_ZIP $TARGET_F
        ;;

    *)  die "Unhandled group <$GROUP>";;
esac

echo; echo "--- Created zip files: ----------------_"
ls -altr ${OP_ZIPS}

