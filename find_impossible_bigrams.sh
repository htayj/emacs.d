#!/usr/bin/env bash
# for a in `echo {a..z}`; do
# for b in `echo {a..z}`; do
# result=`grep -c "$a""$b" "$filename"`;
# echo $a$b : $result >> words.duo


for a in $(echo {a..z}); do
    for b in $(echo {a..z}); do
        forward=$(grep -c "$a""$b" /usr/share/dict/words)
        backward=$(grep -c "$b""$a" /usr/share/dict/words)
        echo "$(($forward+$backward)) $a$b ";
        # echo "$a$b $(grep -c "$a""$b" /usr/share/dict/words)";
    done;
done;
