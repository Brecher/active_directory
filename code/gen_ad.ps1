param( [Parameter(Mandatory=$true)] $JSONFile )

function CreateADGroup(){
    param ( [Parameter(Mandatory=$true)] $groupObject )
    
    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global
}

function RemoveADGroup(){
    param ( [Parameter(Mandatory=$true)] $groupObject )
    
    $name = $groupObject.name
    Remove-ADGroup -Identity $name -Confirm:$false
}

function CreateADUser(){
    param( [Parameter(Mandatory=$true)] $userObject )
    
    # Вытаскиваем имя из JSON object
    $name = $userObject.name
    $password = $userObject.password

    # Генерируем инициалы и lastname структуры для username
    $firstname, $lastname = $name.Split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samAccountName = $username
    $principalname = $username


    #Создаём AD user object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    # Add the user to its group
    foreach($group_name in $userObject.groups) {

        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Warning "User $name not added to group $group_name 'coze does not exists"
        }
    
    }
}

function WeakenPasswordPolicy(){
    secedit /export /cfg C:\Windows\Tasks\secpol.cfg
    (Get-Content C:\Windows\Tasks\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\Windows\Tasks\secpol.cfg
    secedit /configure /db c:\windows\security\local.sdb /cfg C:\Windows\Tasks\secpol.cfg /areas SECURITYPOLICY
    rm -force C:\Windows\Tasks\secpol.cfg -confirm:$false
}

WeakenPasswordPolicy

$json = ( Get-Content $JSONFile | ConvertFrom-JSON)

$Global:Domain = $json.domain

foreach( $group in $json.groups ){
    CreateADGroup $group
}

foreach( $user in $json.users ){
    CreateADUser $user
}