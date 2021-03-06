$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
$log4netDLL = $ScriptDirectory + "\log4net.dll"
$configPath = $ScriptDirectory + "\" + ($MyInvocation.MyCommand.Name -split "\.")[0] + ".config"
$Result = [system.reflection.assembly]::LoadFile($log4netDLL)
$LogManager = [log4net.LogManager]
$logger = $LogManager::GetLogger("PowerShell")
$configFile = new-object System.IO.FileInfo($configPath);    
$xmlConfigurator = [log4net.Config.XmlConfigurator]::ConfigureAndWatch($configFile); 

#$emailList = "verachan.man-in@thomsonreuters.com;allan.lahosky@thomsonreuters.com;rafe.purnell@thomsonreuters.com"
$emailList = "<%= @notify_email %>"
#$smtpRelay = "mailhost.tfn.com";
$smtpRelay = "<%= @smtpRelay %>";

<# Monitor SQL Agent #>
try {
  Gsv -name SQLSERVERAGENT | %{if ($_.status -eq 'Stopped') 
    { sasv -name SQLSERVERAGENT; sleep -Seconds 30; $status = Gsv -name SQLSERVERAGENT;
        [Net.Mail.MailMessage] $message = New-Object Net.Mail.MailMessage;
        $message.From = New-Object net.Mail.MailAddress("feed-win-prod@compass.com");
        $To = $emailList -Split ";";
        $To | foreach {$Message.To.Add((New-Object System.Net.Mail.Mailaddress $_.Trim()))};
        $message.subject = "SQL server on feed-win-prod is downed";
        $message.body = "SQL Agent down. After try to restart it is --> " + $status.status;
  
        $smtp = new-object Net.Mail.SmtpClient($smtpRelay);
        $smtp.Send($message);
        $logger.Warn(": SQLSERVERAGENT service stop. Restart the service.");
    }
  }
  if ($?)
  {
    Gsv -name SQLSERVERAGENT | %{if ($_.status -eq 'Stopped') { $logger.Warn(": SQLSERVERAGENT fail to restart service");} }
  } else
  ##if (-not ($?))
  {
    $logger.Error(': ' + $Error[0].exception.message);
  }
}
catch
{
  $logger.Error(':' + $_.Exception.Message);
}

<# Monitor PerfStat #>
try {
  Gsv -name PerfStat | %{if ($_.status -eq 'Stopped') 
    { sasv -name PerfStat; sleep -Seconds 30; $status = Gsv -name PerfStat;
        [Net.Mail.MailMessage] $message = New-Object Net.Mail.MailMessage;
        $message.From = New-Object net.Mail.MailAddress("feed-win-prod@compass.com");
        $To = $emailList -Split ";";
        $To | foreach {$Message.To.Add((New-Object System.Net.Mail.Mailaddress $_.Trim()))};
        $message.subject = "PerfStat on feed-win-prod is downed";
        $message.body = "PerfStat down. After try to restart it is --> " + $status.status;
  <#      $smtp = new-object Net.Mail.SmtpClient("relay.westlan.com");#>
        $smtp = new-object Net.Mail.SmtpClient($smtpRelay);
        $smtp.Send($message);
        $logger.Warn(": PerfStat service stop. Restart the service.");
    }
  }
  if ($?)
  {
    Gsv -name PerfStat | %{if ($_.status -eq 'Stopped') { $logger.Warn(": PerfStat fail to restart service");} }
  } else
  ##if (-not ($?))
  {
    $logger.Error(': ' + $Error[0].exception.message);
  }
}
catch
{
  $logger.Error(':' + $_.Exception.Message);
}

<# Monitor Sensu=client #>
try {
  Gsv -name sensu-client | %{if ($_.status -eq 'Stopped') 
    { sasv -name sensu-client; sleep -Seconds 30; $status = Gsv -name sensu-client;
        [Net.Mail.MailMessage] $message = New-Object Net.Mail.MailMessage;
        $message.From = New-Object net.Mail.MailAddress("feed-win-prod@compass.com");
        $To = $emailList -Split ";";
        $To | foreach {$Message.To.Add((New-Object System.Net.Mail.Mailaddress $_.Trim()))};
        $message.subject = "sensu-client on feed-win-prod is downed";
        $message.body = "sensu-client down. After try to restart it is --> " + $status.status;
  <#      $smtp = new-object Net.Mail.SmtpClient("relay.westlan.com");#>
        $smtp = new-object Net.Mail.SmtpClient($smtpRelay);
        $smtp.Send($message);
        $logger.Warn(": sensu-client service stop. Restart the service.");
    }
  }
  if ($?)
  {
    Gsv -name sensu-client | %{if ($_.status -eq 'Stopped') { $logger.Warn(": sensu-client fail to restart service");} }
  } else
  ##if (-not ($?))
  {
    $logger.Error(': ' + $Error[0].exception.message);
  }
}
catch
{
  $logger.Error(':' + $_.Exception.Message);
}

<# Monitor nxlog #>
try {
  Gsv -name nxlog | %{if ($_.status -eq 'Stopped') 
    { sasv -name nxlog; sleep -Seconds 30; $status = Gsv -name nxlog;
        [Net.Mail.MailMessage] $message = New-Object Net.Mail.MailMessage;
        $message.From = New-Object net.Mail.MailAddress("feed-win-prod@compass.com");
        $To = $emailList -Split ";";
        $To | foreach {$Message.To.Add((New-Object System.Net.Mail.Mailaddress $_.Trim()))};
        $message.subject = "nxlog on feed-win-prod is downed";
        $message.body = "nxlog down. After try to restart it is --> " + $status.status;
  <#      $smtp = new-object Net.Mail.SmtpClient("relay.westlan.com");#>
        $smtp = new-object Net.Mail.SmtpClient($smtpRelay);
        $smtp.Send($message);
        $logger.Warn(": nxlog service stop. Restart the service.");
    }
  }
  if ($?)
  {
    Gsv -name nxlog | %{if ($_.status -eq 'Stopped') { $logger.Warn(": nxlog fail to restart service");} }
  } else
  ##if (-not ($?))
  {
    $logger.Error(': ' + $Error[0].exception.message);
  }
}
catch
{
  $logger.Error(':' + $_.Exception.Message);
}
