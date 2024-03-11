{ ffmpeg, writeShellApplication }: 
writeShellApplication {
  name = "m4a2mp3";
  runtimeInputs = [ ffmpeg ];
  text = ''
    COUNTER=1
    
    IFS=$'\n'
    for file in $(ls --time=birth -r | grep m4a); do
        INPUT=$file
        OUTPUT=`echo "$${file// /_}" | sed 's/m4a/mp3/g'`
        OUTPUT="$COUNTER.$OUTPUT"
        echo $OUTPUT
        ffmpeg -i "$INPUT" -q:a 0 -map a "$OUTPUT"
        COUNTER=$((COUNTER + 1));
    done
 '';

  checkPhase = '''';
}
