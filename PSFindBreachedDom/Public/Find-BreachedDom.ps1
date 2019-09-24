function Find-BreachedDom {
    [cmdletbinding()]
    param(
        $SavedSearch = "189599",
        [int]$StartPage = 0,
        [int]$Max = 1000,
        [string]$CSVPath
    )

    if ($CSVPath){
    $BreachedList = Import-CSV $CSVPath
    }

    $Result = @()

    for ($i = 0; $i -lt $max; $i += 200 ) {

        Write-Host "Starting at $i."

        $Url = "https://member.expireddomains.net/domains/expiredcom/?start={0}?savedsearch_id={1}&flimit=200&fnumhost=1&fsephost=1&fworden=1" -f $i, $SavedSearch
   
        Write-Host "[EXPIREDDOMAINS] Looking for latest expired domains."

        $r = Invoke-WebRequest -Method GET -Uri $url -WebSession $ExpiredDomainSession

        $Domains = $r.allelements | Where-Object { $_.class -eq "field_domain" } | Select-Object -ExpandProperty InnerText

        Foreach ($Domain in $Domains) {

            if ($BreachedList.Domain -NotContains $Domain){

            Write-Host "[DEHASHED] Looking up domain $Domain"

            $dehashedRes = Invoke-WebRequest -Method GET -Uri "https://dehashed.com/search?query=%22$($domain)%22"

            $Obj = [PSCustomObject]@{
                Domain = $Domain
                Result = [int]$($dehashedRes.AllElements | Where-Object { $_.class -eq "d-block text _500" } | Select-Object -First 1 | Select-Object -ExpandProperty InnerText)
            
            }

            $Result += $Obj
        }
        else {Write-Host "Already checked $Domain. Moving on to next."}
        
        }
    }

    return $Result
}