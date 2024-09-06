

class Rack::Attack

  throttle('logins/email', limit: 30, period: 30.seconds) do |req|
    if req.path == '/users/sign_in' && req.post?
      req.params['user']['email'].presence if req.params['user']
    end
  end

  self.throttled_response = lambda do |env|
    now = Time.now.utc
    match_data = env['rack.attack.match_data']

    retry_after = (match_data || {})[:period] - (now.to_i % match_data[:period])

    [
      429, # status code: Too Many Requests
      { 'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s },
      [{ error: "Throttle limit reached. Retry later." }.to_json]
    ]
  end
end
