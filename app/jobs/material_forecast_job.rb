require 'open3'

class MaterialForecastJob < ApplicationJob
  queue_as :default

  VENV_PYTHON = Rails.root.join('ml', 'venv', 'bin', 'python3').to_s
  TRAIN_SCRIPT = Rails.root.join('ml', 'train_materials.py').to_s
  PREDICT_SCRIPT = Rails.root.join('ml', 'predict_materials.py').to_s

  def perform
    MaterialForecastService.new.call
    run_script(TRAIN_SCRIPT)
    run_script(PREDICT_SCRIPT)
  end

  private

  def run_script(script)
    output, status = Open3.capture2e(VENV_PYTHON, script)
    Rails.logger.info(output)
    raise "#{script} failed: #{output}" unless status.success?
  end
end
