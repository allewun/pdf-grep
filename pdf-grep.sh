#!/bin/bash

# Replace a string in a PDF file.  Requires:
# - qpdf (brew install qpdf)
# - pdftk (https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg)
# - coreutils (brew install coreutils)
#
# Tested on macOS 10.12 Sierra.
#
# Based on remove-watermark.sh from
# https://gist.github.com/elfsternberg/a96883018d783cbbad7b454ecd0a7ffe

if ! hash qpdf 2>/dev/null; then
    echo "qpdf is not installed."
fi

if ! hash pdftk 2>/dev/null; then
    echo "pdftk is not installed."
fi

if [[ -z $4 ]]; then
    echo "Usage: ./pdf-grep.sh <token> <replacement> input.pdf output.pdf"
    exit
fi

SEARCH=$1
REPLACEMENT=$2
INPUT=$3
OUTPUT=$4

if [ -z "$REPLACEMENT" ]; then
    SEARCHLEN=${#SEARCH}
    REPLACEMENT="$(printf %${SEARCHLEN}s)"
fi

UNCOMPRESSED="$(mktemp 'uncompressed-XXXXXXXXXX.pdf')"
FIXED="$(mktemp 'fixed-XXXXXXXXXX.pdf')"
UNMARKED="$(mktemp 'unmarked-XXXXXXXXXX.pdf')"

qpdf --stream-data=uncompress "$INPUT" $UNCOMPRESSED
gsed -e 's/'"$SEARCH"'/'"$REPLACEMENT"'/g' < $UNCOMPRESSED > $FIXED
pdftk $FIXED output $UNMARKED
qpdf --stream-data=compress $UNMARKED "$OUTPUT"
rm $UNCOMPRESSED $FIXED $UNMARKED


# NO WARRANTY
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
