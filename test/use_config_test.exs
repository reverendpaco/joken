defmodule Joken.UseConfig.Test do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Joken.CurrentTime.Mock

  setup do
    start_supervised!(Mock)
    :ok
  end

  describe "__MODULE__.generate_and_sign" do
    test "can use default signer configuration" do
      defmodule DefaultSignerConfig do
        use Joken.Config

        def token_config, do: %{}
      end

      assert DefaultSignerConfig.generate_and_sign() ==
               "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.mwiDnq8rTFp5Oyy5i7pT8qktTB4tZOAfiJXTEbEqn2g"
    end

    test "can pass specific signer" do
      defmodule SpecificSignerConfig do
        use Joken.Config, default_key: :hs256

        def token_config, do: %{}
      end

      assert SpecificSignerConfig.generate_and_sign() ==
               "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.P4Lqll22jQQJ1eMJikvNg5HKG-cKB0hUZA9BZFIG7Jk"
    end

    test "can receive extra claims" do
      defmodule ExtraClaimsConfig do
        use Joken.Config

        def token_config, do: %{}
      end

      assert ExtraClaimsConfig.generate_and_sign(%{"name" => "John Doe"}) ==
               "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UifQ.YSy8oSoFcYMXK2Gn2vcdsSRGtxnYHQ1KGeVOHO_tSbc"
    end
  end
end
