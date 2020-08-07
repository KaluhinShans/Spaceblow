<#import "parts/common.ftl" as c>

<@c.page>
    <h5>${username}</h5>

    <form method="post">
        <#if emailMessage??>
        <div class="form-group row">
            <div class="alert alert-${emailMessageType}" role="alert">
                ${emailMessage}
            </div>
        </div>
        </#if>
        <div class="form-group row">
            <label class="col-sm-2 col-form-label"> Email: </label>
            <div class="col-sm-6">
                <input type="email" class="form-control" name="email" placeholder="Email" value="${email!''}">
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-2 col-form-label"> Password: </label>
            <div class="col-sm-6">
                <input type="password" class="form-control" name="password" placeholder="Password">
            </div>
        </div>
        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
        <button type="submit" class="btn btn-primary">Save</button>
    </form>
</@c.page>