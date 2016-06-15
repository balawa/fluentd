#
# Fluentd
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

require 'fluent/plugin/output'

module Fluent::Plugin
  class BufferedNullOutput < Output
    # This plugin is for tests of buffer plugins

    Fluent::Plugin.register_output('buffered_null', self)

    config_section :buffer do
      config_set_default :chunk_keys, ['tag']
      config_set_default :flush_at_shutdown, true
      config_set_default :chunk_limit_size, 10 * 1024
    end

    attr_accessor :feed_proc, :delayed

    def initialize
      super
      @delayed = false
      @feed_proc = nil
    end

    def prefer_delayed_commit
      @delayed
    end

    def write(chunk)
      if @feed_proc
        @feed_proc.call(chunk)
      else
        # ignore chunk.read
      end
    end

    def try_write(chunk)
      if @feed_proc
        @feed_proc.call(chunk)
      else
        # ignore chunk.read
      end
    end
  end
end