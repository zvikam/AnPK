#!/bin/bash

WORKER_THREADS=${WORKER_THREADS:-1}
DECOMPILE_TOOL=${DECOMPILE_TOOL:=jadx}

[[ -d /input ]] || mkdir /input
[[ -d /output ]] || mkdir /output

die()
{
  >&2 echo "$@"
  exit 1
}

runat()
{
  _LOCATION=$1
  shift
  >/dev/null pushd ${_LOCATION}
  "$@"
  >/dev/null popd
}

extract_apk()
{
  _OUTDIR="$1"
  _APK=$2
  _OPTS=${DECOMPILER_OPTS}
  case ${DECOMPILE_TOOL} in
  jadx)
    _OPTS="${_OPTS} --deobf"
    ;;
  apktool)
    _OPTS="${_OPTS} decode"
    ;;
  *)
    die "unknown DECOMPILE_TOOL ${DECOMPILE_TOOL}"
  esac

  [[ -d ${_OUTDIR} ]] || mkdir -p ${_OUTDIR}
  runat ${_OUTDIR} ${DECOMPILE_TOOL} ${_OPTS} "${_APK}"
}

shopt -s nullglob

if [ -n "${TARGET_APK}" ]
then
  $(python3 -c "import validators; import sys; sys.exit(1 if validators.url(\"${TARGET_APK}\") else 0);")
  if [ $? == 1 ]
  then
    runat /input wget -O target "${TARGET_APK}"
  else
    [[ -f "${TARGET_APK}" ]] && ln -S "${TARGET_APK}" /input/target
  fi
fi

[[ -e "/input/target" ]] || die "APK not specified"

>&2 extract_apk /output/src /input/target

# in case original is an [.xapk] file, analyze internal [.apk] files
for ff in $(find /output/src -type f \( -iname \*.apk -o -iname \*.zip \))
do
  >&2 extract_apk /output/src "${ff}"
done

[[ -d "/output/src" ]] || die "no files to analyze"
python3 /gitGraber/fileGraber.py -m '/output/src/**/*' -t ${WORKER_THREADS} ${GRABER_OPTS}
