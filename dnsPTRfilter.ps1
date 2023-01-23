Get-DnsServerResourceRecord -ComputerName ad01.ortrail.k12.or.us -ZoneName 44.10.in-addr.arpa | Where-Object {$_.Timestamp -le $filterdate}
