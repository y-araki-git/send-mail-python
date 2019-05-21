#!/bin/bash
#
# [スクリプト名]
# send-mail.sh
#
# [引数]
#  なし
#
# [戻り値]
#  0:正常終了
#  1:異常終了
#
# [処理内容]
#  実行結果メール送信
#  終了処理
#
#--------------------------------------------
#============================================
# 作業用変数
#============================================
# タイムスタンプ
NOW=`date "+%Y-%m-%d %H:%M:%S"`
# 日付
TODAY=`date "+%Y%m%d"`
# 作業ルートディレクトリ
WORK_DIR="$(dirname $0)/"
# ログ格納ディレクトリ
LOG_DIR="${WORK_DIR}log"
# スクリプトログファイル
SCRIPT_LOG="${LOG_DIR}/${TODAY}.script.log"

## メール送信用変数
# メール送信スクリプト
PY_SEND_MAIL="${WORK_DIR}/send_mail.py"
# 送信元アドレス
FROM="noreply@xxx"
# 送信先アドレス
TO="server1@mail.test"
# 送信先CCアドレス
CC="user1@mail.test"
# 正常終了時メールタイトル
SUBJECT_SUCCESS="【xxx】処理が完了しました。"
# 異常終了時メールタイトル
SUBJECT_FAILED="【xxx】処理が失敗しました。"
# 例外メールタイトル
SUBJECT_EXCEPTION="【xxx】XXが存在しません。"
# 処理完了メール本文
MAIL_TEMPLATE="${WORK_DIR}/mail-text.txt"
# エラー通知メール本文
ERR_MAIL_TEMPLATE="${WORK_DIR}/error-mail-text.txt"
# エラーアドレス削除結果(str1)
RESULT1="${WORK_DIR}/result/${TODAY}.result1.txt"
# エラーアドレス削除結果(str2)
RESULT2="${WORK_DIR}/result/${TODAY}.result2.txt


######################################################################
# 関数定義
######################################################################
#---------------------------------------------------------------------
# スクリプトログ出力
#---------------------------------------------------------------------
function fnc_output_scriptlog() {
  (echo "$NOW: $1" >>$SCRIPT_LOG) 2>/dev/null
  return $?
}

#---------------------------------------------------------------------
# メール送信関数
#---------------------------------------------------------------------
# 処理成功
function fnc_send_mail() {
  mail_text=$(sed -e 's#%HOSTNAME%#'$(hostname)'#' -e 's#%str1%#'"$(grep flag ${RESULT1} | awk '{print $2}')"'#' -e 's#%str2%#'"$(grep flag ${RESULT2} | awk '{print $2}')"'#' ${MAIL_TEMPLATE})
  echo "${mail_text}" | ${PY_SEND_MAIL} "${FROM}" "${TO}" "${CC}" "${SUBJECT_SUCCESS}"
  return $?
}

# 処理失敗
function fnc_send_error_mail() {
  mail_text=$(sed -e 's#%HOSTNAME%#'$(hostname)'#' -e 's#%str%#'"$1"'#' ${ERR_MAIL_TEMPLATE})
  echo "${mail_text}" | ${PY_SEND_MAIL} "${FROM}" "${TO}" "${SUBJECT_FAILED}"
  return $?
}

# 例外
function fnc_send_exception_mail() {
  mail_text=$(sed -e 's#%HOSTNAME%#'$(hostname)'#' -e 's#%str%#'"$1"'#' ${ERR_MAIL_TEMPLATE})
  echo "${mail_text}" | ${PY_SEND_MAIL} "${FROM}" "${TO}" "${SUBJECT_EXCEPTION}"
  return $?
}

#============================================
# メイン処理
#============================================
#--------------------------------------------
# 実行結果メール送信
#--------------------------------------------
fnc_output_scriptlog "開始:実行結果メール送信"

fnc_send_mail

if [ "$?" != "0" ];then
    for i in fnc_output_scriptlog fnc_send_error_mail; do ${i} "実行結果メール送信に失敗しました。"; done
    exit 1
fi

fnc_output_scriptlog "終了:実行結果メール送信"

#============================================
# 終了処理
#============================================

exit 0

