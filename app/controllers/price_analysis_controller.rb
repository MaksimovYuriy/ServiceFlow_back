class PriceAnalysisController < ApplicationController
  RUNS_LIMIT = 5

  def create
    if (active = PricePrediction.active.first)
      render json: { error: 'analysis_in_progress', run: run_meta(active) }, status: :conflict
      return
    end

    record = PricePrediction.create!(status: :queued)
    PriceAnalysisJob.perform_later(record.id)

    render json: run_meta(record), status: :created
  rescue ActiveRecord::RecordNotUnique
    render json: { error: 'analysis_in_progress', run: run_meta(PricePrediction.active.first) }, status: :conflict
  end

  def show
    record = PricePrediction.completed.recent.first
    if record.nil?
      render json: { error: 'no_completed_run' }, status: :not_found
      return
    end

    render json: {
      run:         run_meta(record),
      predictions: record.predictions,
      metrics:     record.metrics
    }
  end

  def show_latest
    record = PricePrediction.recent.first
    render json: record ? run_meta(record) : nil
  end

  def index_runs
    runs = PricePrediction.recent.limit(RUNS_LIMIT)
    render json: { runs: runs.map { |r| run_meta(r) } }
  end

  private

  def run_meta(record)
    {
      id:            record.id,
      status:        record.status,
      started_at:    record.started_at,
      finished_at:   record.finished_at,
      duration_sec:  duration_sec(record),
      error_message: record.error_message,
      created_at:    record.created_at
    }
  end

  def duration_sec(record)
    return nil if record.started_at.blank?

    finish = record.finished_at || Time.current
    (finish - record.started_at).round
  end
end
