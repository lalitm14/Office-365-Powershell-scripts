<# this powershell script for use with Office 365 for demosntration purpose only developed by lalit mohan on 20th Nov 2015 #>
<# this script provides the number of users that have not logged-in to office 365 for last 30 days, by domains, if more then one domain exist in the tenent #>

<# get credential #>
$cred = get-credential
Import-Module MSOnline


<# initialize valaibles & arrays #>
$domain = ,@()
$ndx=0
$i=0
$days = 30

$a= new-object ‘object[,]’ 2,2
 
for ($ix=0;$ix -lt 2;$ix++)
 {
 for($j=0;$j -lt 2;$j++)
 {
 $a[$ix,$j]=0
 }
} 

<# collect and prepare main data #>

Get-mailbox -resultsize unlimited|Foreach-Object{

    $str1 = $_
    $str1.PrimarySmtpAddress -match '@(.*)$'| out-null
    $str2 = Get-MailboxStatistics $str1.DisplayName
   
if ($str2.lastlogontime) {
if ( ((Get-Date) - ($str2.lastlogontime)).days -gt $days ) {
 $str3 = "inactive"
}


else 
{$str3 = "active"}
}

$NULL =  New-Object -TypeName PSObject -Property @{
        User = $str1.DisplayName 
        Domain = $matches[1]
        Status = $str3
     }
    
    If ($domain[0] -notcontains $matches[1] ) 
  { $domain[0]  += $matches[1]
  $i++}

   $ndx = [array]::IndexOf($domain[0], $matches[1])
  
  if ( $str3 -eq "active") { $a[0,$ndx] += 1 }
   elseif ( $str3 -eq "inactive") { $a[1,$ndx] += 1 }

                                                } 

<# present a summary #>
write-host "------------------------------------------------------------------------------------"
write-host "Note : If user hasn't logged-in for last $days days, he/she is considered not active" 
write-host "------------------------------------------------------------------------------------"
write-host "                                                                                    "

for ($j=0;$j -lt $i;$j++) { 
   $total = $a[0,$j] + $a[1,$j]
   write-host  "For " $domain[0][$j] <#"  " $j#> "of" $total "users" $a[0,$j] "are active."
   write-host  "                                                                         "
   }

write-host "------------------------------------------------------------------------------------"
write-host "                                                                                    "
