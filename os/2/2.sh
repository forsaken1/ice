for FILE in *; do
  if [[ $FILE =~ ([A-Za-z_]+)([0-9]{4,4})([0-9]{4,4})(\..*) ]]; then
    let "year = ${BASH_REMATCH[2]} + 1"
    prefix=`echo "${BASH_REMATCH[1]}" | tr '[:lower:]' '[:upper:]'`
    mv "$FILE" "$prefix$year${BASH_REMATCH[3]}${BASH_REMATCH[4]}"
  fi
done
