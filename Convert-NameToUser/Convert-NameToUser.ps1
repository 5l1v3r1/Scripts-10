
Function Convert-NameToUser()
{
<#
.SYNOPSIS
Convert full names to a configurable email address format.

.DESCRIPTION
Convert full names in to an email address format of <first><seperator><last>@<domain>. Useful when attempting
to generate a list of possible emails for employees scraped from a public source.

.EXAMPLE
Convert-NameToUser -Name 'Bob Alice' -Domain 'domain.tld' -Seperator '_'

.EXAMPLE
cat fullnames.txt | Convert-NameToUser -Domain 'domain.tld' -Seperator '' -FirstToInitial

.NOTES
There's not a whole lot of fancy-ness to this script, will add more features as they are needed/requested.
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$True)]
        [String] $Name,
        
        [Parameter(Mandatory=$True, Position=1)]
        [String] $Domain,
        
        [Parameter(Mandatory=$False, Position=2)]
        [String] $Seperator = '.',
        
        [Parameter(Mandatory=$False)]
        [Switch] $FirstToInitial
    )

    [String[]] $Names = $Name.Replace('\n', '').Split(' ')
    If ($FirstToInitial)
    {
        $Names[0] = ($Names[0].Substring(0, 1))
    }
    "{0}@{1}" -f ($Names -join $Seperator), $Domain
}
