describe user('user1') do
  it { should exist }
end

describe port(80) do
  it { should_not be_listening }
end

describe package('apache2') do
  it { should be_installed }
end
