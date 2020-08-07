package com.shans.spaceblow.controller;

import com.shans.spaceblow.domain.User;
import com.shans.spaceblow.domain.dto.CaptchaResponseDto;
import com.shans.spaceblow.service.UserService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import javax.validation.Valid;
import java.util.Collections;
import java.util.Map;

@Controller
public class RegistrationController {
    private final static String CAPTCHA_URL = "https://www.google.com/recaptcha/api/siteverify?secret=%s&response=%s";
    private final UserService userService;
    private final RestTemplate restTemplate;

    @Value("${recaptcha.secret}")
    private String secret;

    public RegistrationController(UserService userService, RestTemplate restTemplate) {
        this.userService = userService;
        this.restTemplate = restTemplate;
    }

    @GetMapping("/registration")
    public String registration() {
        return "registration";
    }

    @PostMapping("/registration")
    public String addUser(
            @RequestParam("password2") String passwordConfirm,
            @RequestParam("g-recaptcha-response") String recaptcha,
            @Valid User user,
            BindingResult bindingResult,
            Model model
    ) {
        String url = String.format(CAPTCHA_URL, secret, recaptcha);
        CaptchaResponseDto response = restTemplate.postForObject(url, Collections.emptyList(), CaptchaResponseDto.class);

        if (!response.isSuccess()) {
            model.addAttribute("captchaError", "Fill captcha");
        }

        boolean isConfirmEmpty = StringUtils.isEmpty(passwordConfirm);
        if (isConfirmEmpty) {
            model.addAttribute("password2Error", "Password confirmation cannot be empty");
        }
        if (user.getPassword() != null && !user.getPassword().equals(passwordConfirm)) {
            model.addAttribute("passwordError", "Passwords are different");
            return "registration";
        }
        if (bindingResult.hasErrors() || isConfirmEmpty || !response.isSuccess()) {
            Map<String, String> errors = ControllerUtils.getErrors(bindingResult);
            model.mergeAttributes(errors);
            return "registration";
        }

        boolean isUserAdd = userService.addUser(user);
        if (!isUserAdd) {
            model.addAttribute("usernameError", "User exist!");
            return "registration";
        }

        return "redirect:/login";
    }

    @GetMapping("/activate/{code}")
    public String activate(Model model, @PathVariable String code, @AuthenticationPrincipal User user) {
        boolean isActivated = userService.activateUser(code);
        if (isActivated) {
            model.addAttribute("emailMessageType", "success");
            model.addAttribute("emailMessage", "User successfully activated!");
        } else {
            model.addAttribute("emailMessageType", "danger");
            model.addAttribute("emailMessage", "Activation code is not found!");
        }
        if (user == null) {
            return "login";
        } else {
            model.addAttribute("username", user.getUsername());
            model.addAttribute("email", user.getEmail());
        }
        return "profile";
    }
}
