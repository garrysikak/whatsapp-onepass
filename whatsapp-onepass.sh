#!/usr/bin/env bash
# whatsapp-onepass — one encode so WhatsApp's second pass has less to invent.
# Send the result as Document / File, not as "video".
# Usage: whatsapp-onepass.sh [-h HEIGHT] [-c CRF] <input> [output]
set -euo pipefail

HEIGHT=720
CRF=23
PRESET=medium

usage() {
  cat <<'EOF'
Usage: whatsapp-onepass.sh [-h HEIGHT] [-c CRF] <input> [output]

  -h HEIGHT  max height (default 720)
  -c CRF     x264 quality (default 23; lower = bigger)
  -p PRESET  x264 preset  (default medium)

Needs ffmpeg on PATH. Output is H.264 + AAC, yuv420p, +faststart.
WhatsApp will still recompress a "video" send. Attach as Document / File.
EOF
}

while getopts ':h:c:p:' opt; do
  case "$opt" in
    h) HEIGHT=$OPTARG ;;
    c) CRF=$OPTARG ;;
    p) PRESET=$OPTARG ;;
    *) usage; exit 2 ;;
  esac
done
shift $((OPTIND - 1))

if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

IN=$1
OUT=${2:-"${IN%.*}-wa.mp4"}

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg not on PATH" >&2
  exit 1
fi
if [[ ! -f "$IN" ]]; then
  echo "no such file: $IN" >&2
  exit 1
fi

# Even dimensions. Never upscale. WhatsApp's encoder wants yuv420p + AAC stereo.
VF="scale='min(1280,iw)':'min(${HEIGHT},ih)':force_original_aspect_ratio=decrease,scale=trunc(iw/2)*2:trunc(ih/2)*2"

ffmpeg -hide_banner -y -i "$IN" \
  -vf "$VF" \
  -c:v libx264 -preset "$PRESET" -crf "$CRF" -pix_fmt yuv420p \
  -c:a aac -b:a 96k -ac 2 \
  -movflags +faststart \
  "$OUT"

echo "send as DOCUMENT / FILE, not as video: $OUT"
if command -v ffprobe >/dev/null 2>&1; then
  ffprobe -hide_banner -pretty "$OUT" 2>&1 | grep -E 'Duration|Video:|Audio:' || true
fi
