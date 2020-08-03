<#import "parts/common.ftl" as c>

<@c.page>
    List of users:

    <table>
        <head>
            <tr>
                <th>Name</th>
                <th>Role</th>
                <th></th>
            </tr>
        </head>
        <#list users as user>
            <tr>
                <td>${user.username}</td>
                <td><#list user.roles as role>${role}<#sep>, </#list></td>
                <td><a href="/user/${user.id}">edit</a></td>
            </tr>
        </#list>
    </table>
</@c.page>