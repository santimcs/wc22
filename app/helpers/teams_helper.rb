module TeamsHelper
  def flag_url(team_name)
    # First, normalize team names to simple English
    normalized_name = case team_name
    when 'Türkiye'
      'Turkey'
    when 'Côte d’Ivoire'
      'Ivory Coast'
    when 'Curaçao'
      'Curacao'
    else
      team_name
    end
    
    # Map team names to country codes
    country_codes = {
      # Group A
      'Mexico' => 'mx',
      'South Korea' => 'kr',
      'Korea Republic' => 'kr',
      'South Africa' => 'za',
      'Czechia' => 'cz',
      
      # Group B
      'Canada' => 'ca',
      'Switzerland' => 'ch',
      'Qatar' => 'qa',
      'Bosnia and Herzegovina' => 'ba',
      
      # Group C
      'Brazil' => 'br',
      'Morocco' => 'ma',
      'Haiti' => 'ht',
      'Scotland' => 'gb-sct',
      
      # Group D
      'United States' => 'us',
      'USA' => 'us',
      'Paraguay' => 'py',
      'Australia' => 'au',
      'Turkey' => 'tr',           # Fixed
      'Türkiye' => 'tr',         # Alternative
      
      # Group E
      'Germany' => 'de',
      'Curacao' => 'cw',          # Fixed
      'Curaçao' => 'cw',         # Alternative
      'Ivory Coast' => 'ci',      # Fixed
      'Côte d’Ivoire' => 'ci',   # Alternative
      'Ecuador' => 'ec',
      
      # Group F
      'Netherlands' => 'nl',
      'Japan' => 'jp',
      'Sweden' => 'se',
      'Tunisia' => 'tn',
      
      # Group G
      'Belgium' => 'be',
      'Iran' => 'ir',
      'Egypt' => 'eg',
      'New Zealand' => 'nz',
      
      # Group H
      'Spain' => 'es',
      'Saudi Arabia' => 'sa',
      'Uruguay' => 'uy',
      'Cape Verde' => 'cv',
      
      # Group I
      'France' => 'fr',
      'Senegal' => 'sn',
      'Norway' => 'no',
      'Iraq' => 'iq',
      
      # Group J
      'Argentina' => 'ar',
      'Austria' => 'at',
      'Algeria' => 'dz',
      'Jordan' => 'jo',
      
      # Group K
      'Portugal' => 'pt',
      'Colombia' => 'co',
      'Uzbekistan' => 'uz',
      'DR Congo' => 'cd',
      
      # Group L
      'England' => 'gb-eng',
      'Croatia' => 'hr',
      'Ghana' => 'gh',
      'Panama' => 'pa'
    }
    
    code = country_codes[normalized_name] || country_codes[team_name]
    
    if code
      "https://flagcdn.com/w80/#{code}.png"
    else
      "https://via.placeholder.com/70x35?text=#{CGI.escape(team_name[0..2])}"
    end
  end
end
