# Threadsトークン 取トーくん

**Threads Token ShuTo-kun**  
Chrome拡張機能 / v1.0.0

自分のMetaアプリを使って、Threadsの長期アクセストークンを取得するための小さなChrome拡張機能です。

旧Web版「Threads API トークン取得ツール」は、ブラウザのCORS制限により長期トークン交換を安全に完結できなかったため、Chrome拡張機能版へ移行しました。公開CORSプロキシやKINA管理の中継サーバーは使用しません。

## ダウンロード

**[threads-token-extension-v1.0.0.zip をダウンロード](./threads-token-extension-v1.0.0.zip)**

ZIPを展開すると、親フォルダは常に `threads-token-extension` です。

## 主な特徴

- Threads OAuth認証から長期アクセストークン取得までChrome拡張内で完結
- App ID・App Secret・取得したトークンを拡張機能のストレージへ保存しない
- 公開CORSプロキシを使わない
- App SecretやトークンをConsoleへ出力しない
- 長期トークン取得後はApp ID / App Secretを画面から消去
- クロスポスト系ツールとシンプルまるごとZIPで使いやすい3権限を固定で取得
- 長期トークンの自動更新は行わず、使用先アプリ側へ任せる

## インストール

1. 上のZIPをダウンロードして展開します。
2. Chromeで `chrome://extensions` を開きます。
3. 「デベロッパー モード」をONにします。
4. 「パッケージ化されていない拡張機能を読み込む」を押します。
5. 展開した `threads-token-extension` フォルダを選択します。
6. 拡張機能アイコンから **Threadsトークン 取トーくん** を開きます。

## Meta for Developers の設定

取トーくんには、Chrome拡張専用のリダイレクトURLが表示されます。

1. 「コールバックURLをリダイレクト」をコピーします。
2. Meta for DevelopersのThreads API設定へ貼り付けます。
3. 貼り付けると下に同じURLの候補が表示されるので、その候補をクリックして確定してから保存します。貼り付けただけでは未登録です。
4. Threads App IDとThreads App Secretを取トーくんへ入力します。
5. 「Threadsと連携してトークンを取得する」を押します。

「コールバックURLをアンインストール」「コールバックURLを削除」は、個人利用・テスター利用では空欄の状態でも長期トークン取得まで実機確認しています。Meta側で入力を求められた場合はMetaの案内に従ってください。

## 取得する権限

- `threads_basic`
- `threads_content_publish`
- `threads_profile_discovery`

## 実機確認

Chrome + Meta Threads APIの実環境で、OAuth認証と短期→長期アクセストークン交換まで確認しています。

テスト用の秘密情報、App Secret、実アクセストークンはリポジトリへ含めていません。

## ソースコード

拡張機能本体は [`threads-token-extension/`](./threads-token-extension/) にあります。

v1.0.0公開前に、OAuth URL、state検証、短期→長期トークン交換、秘密情報をエラーへ露出させない処理、UIの主要状態など14項目の模擬テストを通過しています。

## 旧Web版について

旧URLは移転案内ページとして残しています。

https://kinappp.github.io/threads-token-tool/
