function LoginExpiredDomains {
    param (
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )

    Add-Type -AssemblyName System.Web

    $UserName = $Credential.UserName
    $Password = $Credential.GetNetworkCredential().Password 

    $expireddomainHost = "https://member.expireddomains.net"

    $Data = "login={0}&password={1}&redirect_2_url=/" -f $Username, [System.Web.HttpUtility]::UrlEncode($Password)

    $headers = @{
        "Content-Type" = "application/x-www-form-urlencoded"
    }

    $r = Invoke-WebRequest -Method POST -Uri $($expireddomainHost + "/login/") -Headers $headers -Body $Data -SessionVariable ExpiredDomainSession -ContentType "application/x-www-form-urlencoded"

    $global:ExpiredDomainSession = $ExpiredDomainSession

    return $r
}