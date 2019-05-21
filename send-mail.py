#!/usr/bin/python
# -*- encoding=utf8 -*-
#
######################################################################
#
# [概要]
#  スクリプトの結果をメール送信する。メール送信に必要な情報は、
#  呼び出し元の関数(fnc_send_mailまたはfnc_send_error_mail)より、
#  引数として受け取る。
#
# [引数]
#  CCあり
#   引数1: 送信元アドレス 
#   引数2: 送信先アドレス
#   引数3: 送信先CCアドレス
#   引数4: メールタイトル
# 
#  CCなし
#   引数1: 送信元アドレス
#   引数2: 送信先アドレス
#   引数3: メールタイトル
#
# ※注記
#  スクリプトの処理が成功している時＝CCあり
#  スクリプトの処理が失敗している時＝CCなし
#
# [関連ファイル]
#  common_difinition.sh
#
######################################################################
# バージョン 作成／更新者 更新日      変更内容
#---------------------------------------------------------------------
# 001-01     XX         YYYY/MM/DD    新規作成
#
######################################################################
######################################################################
# 事前処理
######################################################################
# モジュールインポート
import sys, smtplib
from email.MIMEText import MIMEText
from email.Header import Header
from email.Utils import formatdate
from datetime import datetime

# 作業変数定義
argvs = sys.argv
argc = len(argvs)

today = datetime.now().strftime("%Y%m%d")
now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

######################################################################
# メイン処理
######################################################################
# 文字コード設定
charset = 'cp932'

# アドレス、件名の設定(CCあり)
if (argc == 5):
    from_address = argvs[1]
    to_address   = argvs[2]
    cc_address   = argvs[3]
    subject = unicode(argvs[4], 'utf-8')
# アドレス、件名の設定(CCなし)
elif (argc == 4):
    from_address = argvs[1]
    to_address   = argvs[2]
    subject = unicode(argvs[3], 'utf-8')
# 引数が正しくない場合
else:
    print 'Usage: # %s from to subject' % argvs[0]
    quit()

# 標準入力からメール本文を取得
text = ''
for line in sys.stdin:
    text = text + line
text = unicode(text, 'utf-8')

# 送信メールの作成
msg = MIMEText(text.encode(charset), 'plain', charset)
msg['Subject'] = Header(subject, charset)
msg['From'] = from_address
msg['To'] = to_address
if (argc == 5):
    msg['Cc'] = cc_address
msg['Date'] = formatdate(localtime=True)

# メールの送信
smtp = smtplib.SMTP('localhost')
if (argc == 5):
    smtp.sendmail(from_address, [to_address, cc_address], msg.as_string())
else:
    smtp.sendmail(from_address, to_address, msg.as_string())
smtp.close()

######################################################################
# 事後処理
######################################################################
#ログ出力
f = open("/root/xxx/log/" + today + ".script.log",'a')
if (argc == 5):
    f.write(now + ": 実行結果メールが送信されました。\n")
else:
    f.write(now + ": エラー通知メールが送信されました\n")
f.close()

sys.exit(0)

