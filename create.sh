#!/bin/bash
if [[ $BASH_VERSINFO -ge 4 ]];
 then
  :
 else
  echo 'bashをアップグレードして下さい。'
  exit 1
fi
if hash sed;
 then
  :
 else
  echo 'sedをインストールして下さい。'
  exit 1
fi
json='{\n'
echo -n '名前を入力:'
read name
if [[ -n $name ]];
 then
  json+='\t"name": "'$name'",\n'
fi
echo -n 'あまにゃんへの信仰心の誓いなどを入力:'
read description
if [[ -n $description ]];
 then
  json+='\t"description": "'$description'",\n'
fi
json+='\t"information": {'
PS3='所持しているアカウントを選択:'
while :
 do
  select information in Twitter GitHub Medium Qiita Instagram Google+ Facebook 終了
   do
    case $information in
     '終了')
      json=${json%,}'\n\t}\n}\n'
      if hash jq 2>/dev/null;
       then
        echo $json | sed 's/\\[nt]//g' | jq .
       else
        echo -e $json | sed 's/\t/  /g'
      fi
      echo -n 'これでよろしいですか? (Y/N)'
      while read yn
       do
        case ${yn,} in
         'y') break ;;
         'n') exit 1 ;;
        esac
      done
      echo -n 'ファイル名を入力:'
      while read file
       do
        if [[ -n $file ]]
         then
          echo -e $json | sed 's/\t/  /g' > $file
          break
        fi
      done
      exit
      ;;
     *)
      if [[ -n $information ]]
       then
        echo -n "${information}のID(ScreenName)を入力:"
        read id
        if [[ -n $id ]];
         then
          json+='\n\t\t"'${information,,}'": "'$id'",'
        fi
      fi
      ;;
    esac
  done
done
