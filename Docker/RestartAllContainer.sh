for d in */; do
  cd $d

  CONT_ID=$(docker-compose ps --quiet)
  echo '[+]' $d $CONT_ID
  if [[ "$CONT_ID" != "" ]]; then
    docker exec $CONT_ID bash -c 'ps -ax | grep ShareMemory'
    if [[ $? -ne 1 ]]; then                                      
      echo '[+] Container is running'
      # After all stopped
      # docker-compose up -d
  
      # docker exec $CONT_ID bash -c 'cd /home/tlbb && ./run.sh'
    fi
  fi
  
  cd ..
done 

