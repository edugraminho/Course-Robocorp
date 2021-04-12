*** Settings ***
Documentation   Template robot main suite.
Library           RPA.Browser.Selenium
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.PDF
Library           RPA.Robocloud.Secrets


*** Keywords ***
Abrir Website Robocorp
    Open Available Browser    https://robotsparebinindustries.com/

*** Keywords ***
Log In
    ${secret}    Get Secret    robotsparebin
    Input Text    id:username    ${secret}[username]
    Input Password    id:password    ${secret}[password]
    Submit Form
    Wait Until Page Contains Element    id:sales-form

*** Keywords ***
Preencher formulario do vendedor
    [Arguments]    ${sales_rep}
    Input Text    firstname    ${sales_rep}[First Name]
    Input Text    lastname    ${sales_rep}[Last Name]
    Input Text    salesresult    ${sales_rep}[Sales]
    ${target_as_string}=    Convert To String    ${sales_rep}[Sales Target]
    Select From List By Value    salestarget    ${target_as_string}
    Click Button    Submit

*** Keywords ***
Download Arquivo Excel
    Download    https://robotsparebinindustries.com/SalesData.xlsx    overwrite=True

*** Keywords ***
Usar excel para preencher formulario
    Open Workbook    SalesData.xlsx
    ${sales_reps}    Read Worksheet As Table    header=True
    Close Workbook
    FOR    ${sales_rep}    IN    @{sales_reps}
        Preencher formulario do vendedor    ${sales_rep}
    END

*** Keywords ***
Coletar Resultados
    Screenshot    css:div.sales-summary    ${CURDIR}${/}output${/}sales_summary.png

*** Keywords ***
Exportar tabela em PDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}    Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf    ${sales_results_html}    ${CURDIR}${/}output${/}sales_results.pdf

*** Keywords ***
Log Out e Fechar o Browser
    Click Button    Log out
    Close Browser

*** Tasks ***
Inserir dados de venda e exportar como PDF
    Abrir Website Robocorp
    Log In
    Download Arquivo Excel
    Usar excel para preencher formulario
    Coletar Resultados
    Exportar tabela em PDF
    [Teardown]    Log Out e Fechar o Browser
    # o Teardown vai funcionar mesmo que o robo quebre



