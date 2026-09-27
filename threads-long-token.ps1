# Threads 長期トークン交換用（Windows PowerShell / PowerShell 7）
# Meta公式APIへの通信のみ。値の保存・ログファイル出力は行いません。
# ご自身のApp Secretと短期トークンだけを入力してください。
$ErrorActionPreference = 'Stop'
function Read-HiddenText([string]$Message) {
    $secure = Read-Host $Message -AsSecureString
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
}
Write-Host 'Threads 長期トークンへの交換（ローカル実行）'
Write-Host '入力内容は表示・保存されず、Metaのgraph.threads.netへ直接送信されます。'
$secret = Read-HiddenText 'Threads App Secret（貼り付け）'
$short = Read-HiddenText '短期トークン（ブラウザの「コピー」を使用）'
if ([string]::IsNullOrWhiteSpace($secret) -or [string]::IsNullOrWhiteSpace($short)) {
    Write-Host 'App Secretと短期トークンが必要です。' -ForegroundColor Red
    exit 1
}
try {
    $uri = 'https://graph.threads.net/access_token?grant_type=th_exchange_token' +
        '&client_secret=' + [Uri]::EscapeDataString($secret) +
        '&access_token=' + [Uri]::EscapeDataString($short)
    $response = Invoke-RestMethod -Method Get -Uri $uri -TimeoutSec 40 -ErrorAction Stop
    $uri = $null
    if (-not $response.access_token) { throw 'empty response' }
    $days = [math]::Round([double]$response.expires_in / 86400, 1)
    Write-Host "長期トークン取得成功！ 有効期間（応答値）：約 $days 日" -ForegroundColor Green
    Write-Host '長期アクセストークン：'
    Write-Output $response.access_token
    $answer = Read-Host '長期トークンをクリップボードへコピーしますか？ (y/N)'
    if ($answer -eq 'y' -or $answer -eq 'Y') {
        Set-Clipboard -Value $response.access_token
        Write-Host 'コピーしました。貼り付け後はクリップボードの内容に注意してください。'
    }
} catch {
    # 例外にはアクセストークン入りURLが含まれ得るため、例外の全文を表示しない。
    Write-Host '交換に失敗しました。短期トークンの期限・App Secret・Metaの接続状態を確認してください。' -ForegroundColor Red
    exit 1
} finally {
    $secret = $null
    $short = $null
    $uri = $null
}
