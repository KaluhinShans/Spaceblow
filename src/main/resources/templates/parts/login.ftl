<#macro login path isRegisterForm>
    <form action="${path}" method="post">
        <div class="form-group row">
            <label class="col-sm-2 col-form-label"> User Name : </label>
            <div class="col-sm-6">
                <input type="text" value="<#if user??>${user.username}</#if>"
                       class="form-control ${(usernameError??)?string('is-invalid','')}"
                       name="username" placeholder="User name">
                <#if usernameError??>
                    <div class="invalid-feedback">
                        ${usernameError}
                    </div>
                </#if>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-2 col-form-label"> Password: </label>
            <div class="col-sm-6">
                <input type="password"
                       class="form-control ${(passwordError??)?string('is-invalid','')}"
                       name="password" placeholder="Password">
                <#if passwordError??>
                    <div class="invalid-feedback">
                        ${passwordError}
                    </div>
                </#if>
            </div>
        </div>
        <#if isRegisterForm>
        <div class="form-group row">
            <label class="col-sm-2 col-form-label"> Confirm password: </label>
            <div class="col-sm-6">
                <input type="password"
                       class="form-control ${(password2Error??)?string('is-invalid','')}"
                       name="password2" placeholder="Confirm password">
                <#if password2Error??>
                    <div class="invalid-feedback">
                        ${password2Error}
                    </div>
                </#if>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-sm-2 col-form-label"> Email: </label>
            <div class="col-sm-6">
                <input type="email" value="<#if user??>${user.email}</#if>"
                       class="form-control ${(emailError??)?string('is-invalid','')}"
                       name="email" placeholder="Email">
                <#if emailError??>
                    <div class="invalid-feedback">
                        ${emailError}
                    </div>
                </#if>
            </div>
            <div class="col-sm-6 mt-3">
                <div class="g-recaptcha" data-sitekey="6Le077sZAAAAAIeMmf4scOUpty-44ymjx8yMb39t"></div>
                <#if captchaError??>
                    <div class="alert alert-danger mt-3" role="alert">
                        ${captchaError}
                    </div>
                </#if>
            </div>
            </#if>
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <#if !isRegisterForm>
                <a href="/registration">Add new user</a>
            </#if>
            <br>
            <div class="col-sm-6 mt-3">
                <button type="submit" class="btn btn-primary">
                    <#if isRegisterForm>Create<#else>Sign In</#if></button>
            </div>
    </form>
</#macro>

<#macro logout>
    <form action="/logout" method="post">
        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
        <button type="submit" class="btn btn-primary">Sign Out</button>
    </form>
</#macro>