param( [Parameter(Mandatory=$true)] $OutputJSONFILE )

$group_names = (Get-Content "data/group_names.txt")
$first_names = (Get-Content "data/first_names.txt")
$last_names = (Get-Content "data/last_names.txt")
$passwords = (Get-Content "data/passwords.txt")

$groups = @()
$users = @()

$num_groups = 10

for ($i = 0; $i -lt $num_groups; $i++) {
    $group_name = (Get-Random -InputObject $group_names)
    $group = @{ "name" = "$group_name" }
    $groups += $group
    $group_names.Remove($group_name)
}

$num_users = 100

for ($i = 0; $i -lt $num_users; $i++) {
    $first_name = (Get-Random -InputObject $first_names)
    $last_name = (Get-Random -InputObject $last_names)
    $password = (Get-Random -InputObject $passwords)
    $new_user = @{
        "name" = "$first_name $last_name"
        "password" = "$password"
        "groups" = @( (Get-Random -InputObject $groups).name )
        }
    $users += $new_user
    $first_names.Remove($first_name)
    $last_names.Remove($last_name)
    $passwords.Remove($password)
}

Write-Output @{
       "domain" = "COVEN.local"
       "groups" = $groups
       "users" = $users
} | ConvertTo-Json | Out-File $OutputJSONFILE