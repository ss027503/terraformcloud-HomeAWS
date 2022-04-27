locals {
    project_name = "aws-gaming"
    vpc_id = "vpc-87d13fee"
    
    instance_type = "g4dn.xlarge"
    instance_key = "home-use2"

    host_name           = "aws-gaming01"
    root_volume_size    = 60
    extra_volume_size   = 400
}

resource "aws_instance" "this" {
    ami                     = data.aws_ami.win2019.id
    instance_type           = local.instance_type
    vpc_security_group_ids  = [aws_security_group.this.id]
    subnet_id               = data.aws_subnet.this.id
    key_name                = local.instance_key
    iam_instance_profile    = aws_iam_instance_profile.this.name

    user_data = <<-EOF
		<powershell>
        Set-ExecutionPolicy -ExecutionPolicy unrestricted
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Rename-Computer -NewName "${local.host_name}" -Force
        Set-TimeZone -Name "Central Standard Time"
        choco install -y firefox putty winscp 7zip notepadplusplus vlc sumatrapdf steam

        $Bucket = "nvidia-gaming"
        $KeyPrefix = "windows/latest"
        $LocalPath = "$home\Desktop\NVIDIA"
        $Objects = Get-S3Object -BucketName $Bucket -KeyPrefix $KeyPrefix -Region us-east-1
        foreach ($Object in $Objects) {
            $LocalFileName = $Object.Key
            if ($LocalFileName -ne '' -and $Object.Size -ne 0) {
                $LocalFilePath = Join-Path $LocalPath $LocalFileName
                Copy-S3Object -BucketName $Bucket -Key $Object.Key -LocalFile $LocalFilePath -Region us-east-1
            }
        }
        $driverfile = Get-childItem "$home\desktop\NVIDIA\windows\latest\" | Select-Object -ExpandProperty Name
        Expand-Archive -Path "$home\Desktop\NVIDIA\windows\latest\$driverfile" -DestinationPath "$home\Desktop"

        # INSTALL 

        Remove-Item -Path $LocalPath -Recurse -Force
        sleep 2
        Remove-Item -Path $LocalPath -Recurse -Force

        New-ItemProperty -Path "HKLM:\SOFTWARE\NVIDIA Corporation\Global" -Name "vGamingMarketplace" -PropertyType "DWord" -Value "2"
        Invoke-WebRequest -Uri "https://nvidia-gaming.s3.amazonaws.com/GridSwCert-Archive/GridSwCertWindows_2021_10_2.cert" -OutFile "$Env:PUBLIC\Documents\GridSwCert.txt"
        Restart-Computer -Force
        </powershell>
	EOF

    root_block_device {
        delete_on_termination   = true
        encrypted               = false
        volume_type             = "gp3"
        volume_size             = local.root_volume_size
    }
    ebs_block_device {
        device_name             = "xvdf"
        delete_on_termination   = true
        encrypted               = false
        volume_type             = "gp3"
        volume_size             = local.extra_volume_size
    }
    
    tags = {
        Name                = local.host_name
    }
}