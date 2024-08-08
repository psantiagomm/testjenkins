package com.example.testjenkins.config;

import java.text.MessageFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.context.MessageSource;
import org.springframework.context.NoSuchMessageException;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.ObjectUtils;

@Component
@RefreshScope
public class Messages {
	
	@Autowired
	private MessageSource messageSource;
	
	public String getKey(String key) {
		String value = null;
		if(ObjectUtils.isEmpty(key))
			throw new NullPointerException("Key " + key + "not exists in messages.properties");
		try {
			value = messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
		}catch (NoSuchMessageException e) {
			value = "Please define the message in messages.properties from key " + key;
		}
		return value;
	}
	
	public String format(String message, Object ...parms) {
		return MessageFormat.format(message, parms);
	}
}
