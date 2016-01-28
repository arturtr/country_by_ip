# Country by IP

## Requirements

* PostgreSQL database

## API methods

GET response to path
```
/api/country_by_ip?ip=123.123.123.123
```

will return country name in JSON format
```ruby
{
  country: "China",
  ip: "123.123.123.123"
}
```

## CRON

For add monthly IP database update to CRON run
```
whenever -w
```

For remove this task from CRON run
```
whenever -c
```
