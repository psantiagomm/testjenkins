package com.example.testjenkins.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.core.env.Environment;


@Configuration
@RefreshScope
public class CustomMessageSourceConfiguration {
	
	@Autowired
    Environment env;
    
	@Bean
	@RefreshScope
	public MessageSource messageSource() {
		ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();

		if(env.getProperty(AppConstants.PROPERTIES_PATH) != null) {
			StringBuilder base = new StringBuilder("");
			base.append(env.getProperty(AppConstants.PROPERTIES_PATH));
			base.append("/messages");
			messageSource.setBasenames(base.toString(), "classpath:messages");
		} else {
			messageSource.setBasename("classpath:messages");
		}
		
		messageSource.setDefaultEncoding("UTF-8");
		messageSource.setCacheSeconds(10);
		return messageSource;
	}
}
